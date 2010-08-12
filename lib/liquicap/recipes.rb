Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :deploy do

    namespace :liquibase do

      desc <<-DESC
        Remotely runs Liquibase migrations for a Java Maven project.

        Required Arguments (examples specified):
        set :mvn_git_repo,        "git@github.com:ienders/my_java_app.git"
        set :mvn_profile,         "my_java_app,production"

        OPTIONAL:
        set :m2_home,             "/usr/local/apache-maven-2.1.0"  --> defaults to M2_HOME of your deploy user
        set :java_home,           "/usr/local/jdk1.6.0_14" --> defaults to use JAVA_HOME of your deploy user
      DESC
      task :update, :roles => :java do
        require 'net/http'

        raise ArgumentError, "Must set mvn_git_repo" unless mvn_git_repo = fetch(:mvn_git_repo, nil)
        raise ArgumentError, "Must set mvn_profile" unless mvn_profile = fetch(:mvn_profile, nil)

        m2_home = fetch(:m2_home, nil)
        java_home = fetch(:java_home, nil)

        mvn_command = m2_home ? "#{m2_home}/bin/mvn" : 'mvn'
        exports = ''
        exports = "export M2_HOME=#{m2_home} && " if m2_home
        exports = "export JAVA_HOME=#{java_home} && #{exports}" if java_home

        run <<-CMD
          if [ -d #{shared_path}/cached-java-app-copy ]; then cd #{shared_path}/cached-java-app-copy && git pull; else git clone #{mvn_git_repo} #{shared_path}/cached-java-app-copy && cd #{shared_path}/cached-java-app-copy; fi
        CMD
        run "#{exports} cd #{shared_path}/cached-java-app-copy && #{mvn_command} process-resources liquibase:update -P#{mvn_profile}"
      end
    end
  end

  
end