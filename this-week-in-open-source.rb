#!/usr/bin/ruby

require "github_api"

puts "This Week In Open Source"
puts ""
one_week_in_seconds = 60 * 60 * 24 * 7
github = Github.new
owner = ARGV[0]
repo_list = ARGV[1..]
repo_list.each do |repo|
  commits = github.repos.commits.list owner, repo, since: Time.now - one_week_in_seconds
  commit_hash_by_author = Hash.new([])
  commits.each { |commit| commit_hash_by_author[commit.author.login] = commit_hash_by_author[commit.author.login] << commit }
  next unless commits.any?
  puts "## [#{repo}](#{github.repos.get(owner, repo).html_url}) \n\n"
  commit_hash_by_author.each do |author, commits|
    commit = commits.first
    puts "#{commit.commit.author.name}([#{author}](#{commit.author.html_url}))"
    commits.each do |commit| 
      puts "    [#{commit.sha[0...7]}](#{commit.html_url})"
    end
    puts ""
  end
  puts ""
end
