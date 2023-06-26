#!/usr/bin/ruby

require "github_api"

one_week_in_seconds = 60 * 60 * 24 * 7
github = Github.new
owner = ARGV[0]
repo_list = ARGV[1..]
repo_list.each do |repo|
  commit_list = github.repos.commits.list owner, repo, since: Time.now - (one_week_in_seconds)
  commit_hash_by_author = commit_list.group_by { |commit| commit.author.login }
  next unless commit_list.any?

  puts "## [#{repo}](#{github.repos.get(owner, repo).html_url}) \n\n"
  commit_hash_by_author.each do |author_handle, commits|
    first_commit = commits.first
    puts "#{first_commit.commit.author.name} ([#{author_handle}](#{first_commit.author.html_url}))"
    commits.each do |commit| 
      puts "([#{commit.sha[0...7]}](#{commit.html_url}))"
    end
    puts ""
  end
  puts ""
end
