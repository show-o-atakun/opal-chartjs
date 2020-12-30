require "opal"
require "opal/chartjs"

# ここから続くのはほとんどデータ下準備----------
data1 = [35000, 39500, 103400, 115000, 132851, 183183]
data2 = [56222, 10353, 32623, 110056, 235261, 90089]
title1 = '走行距離1[km]'
title2 = '走行距離2[km]'

datasets1 = [{
    label: title1, data: data1,
    backgroundColor: Opal::Chartjs.default_color(5), borderWidth: 1
},
{
    label: title2, data: data2,
    backgroundColor:  Opal::Chartjs.default_color(6), borderWidth: 1
}] # backgroundcolorとかはデフォルト値が欲しいところ

datasets2 = [{
    label: title1, data: data1,
    backgroundColor: Opal::Chartjs.random_color, borderWidth: 1
},
{
    label: title2, data: data2,
    backgroundColor:  Opal::Chartjs.random_color, borderWidth: 1
}] # backgroundcolorとかはデフォルト値が欲しいところ

xlabels = ["7月", "8月", "9月", "10月", "11月", "12月"]
# ここまで下準備

# gemにてチャート表示実行！
opcex = Opal::Chartjs::Chartjs.new
opcex.chart_bar("chart1", datasets1, xlabels: xlabels)
opcex.chart_bar("chart2", datasets2, xlabels: xlabels)
