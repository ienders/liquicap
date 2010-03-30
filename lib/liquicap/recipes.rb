Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :deploy do
    
    namespace :java do
    
      desc <<-DESC
        Remotely runs Liquibase migrations for a Java Maven project.
      
        Required Arguments (examples specified):
        set :mvn_git_repo,        "git@github.com:ienders/my_java_app.git"
        set :mvn_profile,         "my_java_app,production"
      DESC
      task :migrate, :roles => :java, :except => { :no_release => true } do
        require 'net/http'

        raise ArgumentError, "Must set mvn_git_repo" unless mvn_git_repo = fetch(:mvn_git_repo, nil)
        raise ArgumentError, "Must set mvn_profile" unless mvn_profile = fetch(:mvn_profile, nil)

        run <<-CMD
          if [ -d #{shared_path}/cached-java-app-copy ]; then cd #{shared_path}/cached-java-app-copy && git pull; else git clone #{mvn_git_repo} #{shared_path}/cached-java-app-copy && cd #{shared_path}/cached-java-app-copy; fi
        CMD
        
        run "cd #{shared_path}/cached-java-app-copy && mvn process-resources liquibase:update -P#{mvn_profile}"
      end
    end
  end
  
end