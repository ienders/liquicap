= liquicap

== DESCRIPTION:

Capistrano tasks which allow you to quickly and easily run Java migrations (similar to cap deploy:migrate for Rails) using Liquibase.

Makes a wonderful companion to tomcap! (http://github.com/ienders/tomcap)

== REQUIREMENTS:

* capistrano (http://capify.org)
* maven installed on your deploy host. (http://maven.apache.org)
* A maven project which has a dependency on liquibase (checked into git) (http://www.liquibase.org)

== INSTALLATION:

 $ gem sources -a http://gems.github.com/ (if you havn't already, which is unlikely)
 $ gem install ienders-liquicap

== USAGE:

= Include in capistrano

In your deploy.rb, simply include this line at the top:

  require 'liquicap/recipes'

= Set your configuration parameters

liquicap checks out a cached copy of your Java repo from git, and will run liquibase directly from there.  Specify any profiles
you use via :mvn_profile.  (For example, your staging environment may run a staging profile, prod uses prod, etc.)

  set :mvn_git_repo, "git@github.com:ienders/my_java_app.git"
  set :mvn_profile,  "my_java_app,production"

= Assign a java role to the server you want to run your liquibase migration from

(username and pass should be set in your other deployment settings as normal for say, a Rails app)

  role :java, 'myhost.com'

= Deploy

  $ cap <environment> deploy:java:migrate

== AUTHOR:

Ian Enders
addictedtoian.com
