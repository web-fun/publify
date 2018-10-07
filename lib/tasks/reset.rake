namespace :demo do
  # Based on https://stackoverflow.com/questions/28515857/reset-database-with-rake-task/28516002#28516002
  desc 'Reset demo data'
  task reset: :environment do
    ActiveRecord::Base.connection.tables.each do |table|
      table.singularize.camelize.constantize.destroy_all
    rescue NameError
      puts "Class for #{table} not found; Skipping ..."
    end

    Rails.application.load_seed

    text_filter = TextFilter.find_by name: 'markdown'
    user = User.create!(name: 'Admin',
                        login: 'admin',
                        email: 'admin@example.com',
                        password: 'admin123',
                        text_filter: text_filter)
    blog = Blog.first
    blog.update!(base_url: ENV['BASE_URL'].to_s,
                 blog_name: 'Publify Demo')
    blog.articles.build(title: I18n.t('setup.article.title'),
                        author: user.login,
                        body: I18n.t('setup.article.body'),
                        allow_comments: 1,
                        allow_pings: 1,
                        user: user).publish!
    publisher = User.create!(email: 'demo@example.com',
                             login: 'demo',
                             name: 'Demo Publisher',
                             password: 'demo1234',
                             text_filter: text_filter,
                             profile: 'publisher')
  end
end
