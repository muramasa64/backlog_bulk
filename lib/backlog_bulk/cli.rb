# coding: utf-8
require 'backlog_bulk'
require 'backlog_jp'
require 'logger'
require 'thor'

module BacklogBulk
  class CLI < Thor
    class_option :config, aliases: [:c], type: :string, desc: "use config file", default: "backlog_bulk.conf"
    class_option :debug, aliases: [:d], type: :boolean, desc: "enable debug mode", default: false

    desc "issue --projects project_key_file", ""
    option :projects, aliases: [:p], type: :string, desc: "project key each line"
    def issue
      conf = BacklogBulk::Config.new(options)
      @client = BacklogJp::Client.new(space: conf.space, api_key: conf.api_key)
      $stderr.puts @client.inspect if conf.debug
      priority_id = get_priority_id(@client)
      unless priority_id
        $stderr.puts "initialize failed: priority_id => nil"
        exit 1
      end

      open(conf.projects, 'r').each_line do |project_key|
        project_key.chomp!
        project_id, issue_type_id = init_project(@client, project_key)
        unless project_id && issue_type_id
          $stderr.puts "initialize failed: project_key =>#{project_key}, projec_id => #{project_id.inspect}, issue_type => #{issue_type_id.inspect}"
          exit 1
        end

        begin
          result = @client.post 'issues',
            'projectId': project_id,
            'issueTypeId': issue_type_id,
            'summary': conf.summary,
            'startDate': conf.startDate,
            'priorityId': priority_id,
            'description': conf.description
          puts "post new issue success: project_key => #{project_key} issueKey => #{result[:issueKey]}"
        rescue BacklogJp::Client::APIException => e
          $stderr.puts "post new issue failed: project_key => #{project_key} #{e}"
        end
      end
    end

    desc "comment --issuekeys issuekeysfile --content content_name", ""
    option :issuekeys, aliases: [:i], type: :string, desc: "issuekey each line", required: true
    option :content, aliases: [:t], type: :string, desc: "content_name in config file", required: true
    def comment
      conf = BacklogBulk::Config.new(options)
      @client = BacklogJp::Client.new(space: conf.space, api_key: conf.api_key)
      $stderr.puts @client.inspect if conf.debug

      open(conf.issuekeys, 'r').each_line do |issuekey|
        issuekey.chomp!

        begin
          result = @client.post "issues/#{issuekey}/comments",
            content: conf[conf.content]
          puts "post new comment success: issuekey => #{issuekey}, id => #{result[:id]}"
        rescue BacklogJp::Client::APIException => e
          $stderr.puts "post new comment failed: project_key => #{project_key} #{e}"
        end
      end
    end

    private
    def init_project(client, project_key)
      [get_project_id(client, project_key), get_last_issue_type_id(client, project_key)]
    end

    def get_project_id(client, project_key)
      p project_key
      begin
        project = client.get "projects/#{project_key}"
        return project[:id]
      rescue BacklogJp::Client::APIException => e
        $stderr.puts "get projects failed: project_key => #{project_key} #{e}"
      end
    end

    def get_priority_id(client)
      begin
        priorities = client.get 'priorities'
        priority = priorities.find {|pri| pri[:name] == '中'}
        return priority[:id]
      rescue BacklogJp::Client::APIException => e
        $stderr.puts "get priorities failed: #{e}"
      end
    end

    def get_last_issue_type_id(client, project_key)
      begin
        issue_types = client.get "projects/#{project_key}/issueTypes"
        issue_type = issue_types.max_by {|ts| ts[:displayOrder]}
        return issue_type[:id]
      rescue BacklogJp::Client::APIException => e
        $stderr.puts "get issueTypes failed: project_key => #{project_key} #{e}"
      end
    end
  end
end
