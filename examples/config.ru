# このディレクトリでのbundler install で gemのほうの更新を細やかに取り込みつつ、
# bundler exec rakckup -o 0.0.0.0 し、ブラウザで:9292を開く。
require "opal-sprockets"

Opal.use_gem "opal-chartjs"

run Opal::Sprockets::Server.new {|s|
    s.append_path 'app'
    s.main = 'application'
}