require "json"
require "erb"

if RUBY_ENGINE=='opal'
  # 他のrubyファイルがあり、呼び出したいときは
  # require_relative "opal_chart/exam_alert"
  # とするが、今回は無し
else
  require "opal_chart/version"
  require "opal"
  
  Opal.append_path File.expand_path('..', __FILE__)
end

module Opal
  module Chartjs
    class Error < StandardError; end
    
    class Chartjs
      def initialize
        @added=[]
      end

      def chart_bar(chart_id, datasets, xlabels: nil, parent: nil)
        # xlabels指定なしだと現状はエラー
        # 1, 2, 3,... と表記してあげたら乙かねえ

        `
          // Chart.js スクリプト読み込み
          var req = new XMLHttpRequest();
          req.open("GET", "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js", false);
          req.send("");

          // 上のreq.openでは同期通信(false)を指定しているので以下はレスポンスを待ってから実行される。
          // 文字列をjavascriptとして実行。
          eval(req.responseText);
        `
        chart_bar_draw(chart_id, datasets, xlabels: xlabels, parent: parent)
      end

      def chart_bar_draw(chart_id, datasets, xlabels: nil, parent: nil)
        
        json_datasets = JSON[datasets]
        add_component("canvas", chart_id, parent: parent)

        # Draw Bar Chart
        `
          const parsed_datasets = JSON.parse(json_datasets)
          var ctx = document.getElementById(chart_id);
          var myChart = new Chart(ctx, {
              type: 'bar',
              data: {
                  labels: xlabels,
                  datasets:parsed_datasets
              },
              options: {
                  scales: {
                      yAxes: [{
                          ticks: {
                              beginAtZero:true
                          }
                      }]
                  }
              }
          });
        `
      end

      def add_component(component, id, parent: nil)
        `
          // add Arbitrary DOM
          var element = document.createElement(component);
          element.setAttribute("id", id);
        `
        @added << `element`

        if !parent.nil?
          # 親コンテナ指定ありの場合  
          `
            const prt = document.getElementById(parent);
            prt.appendChild(#{@added.last})
          `
        else
          # なしの場合: bodyに直貼り付け
            `document.body.appendChild(#{@added.last})`
        end

        return @added.last
      end
    end

    module_function

    def default_color(index)
      # Prepare Default 10 Colors
      case index % 12
      when 0;  'rgba(255,  99, 132, 0.2)'
      when 1;  'rgba( 99, 255, 132, 0.2)'
      when 2;  'rgba( 99, 132, 255, 0.2)'
      when 3;  'rgba(132,  99, 255, 0.2)'
      when 4;  'rgba(255, 132,  99, 0.2)'
      when 5;  'rgba(132, 255,  99, 0.2)'
      when 6;  'rgba( 99, 180, 200, 0.2)'
      when 7;  'rgba(180,  99, 200, 0.2)'
      when 8;  'rgba( 99, 200, 180, 0.2)'
      when 9;  'rgba(200,  99, 180, 0.2)'
      when 10; 'rgba(180, 200,  99, 0.2)'
      when 11; 'rgba(200, 180,  99, 0.2)'
      end
    end

    def random_color(a: 0.2)
      srand
      r = rand(256)
      g = rand(256)
      b = rand(256)
      rgba = "rgba(#{r},#{g},#{b},#{a})"
      p rgba
      return rgba
    end

  end # Module Chartjs
end # Module Opal