require 'nokogiri'
require 'open-uri'
require 'json'

baseurl = "https://sites.google.com/site/cfecardgame/rule/latest/"
links = {
  base: "#{baseurl}basicrule",
  star: "#{baseurl}star",
  field: "#{baseurl}field",
  hero: "#{baseurl}hero",
  warrior: "#{baseurl}hero/warrior",
  seeker: "#{baseurl}hero/seeker",
  mesmer: "#{baseurl}hero/mesmer",
  mage: "#{baseurl}hero/mage",
  windwalker: "#{baseurl}hero/windwalker",
  others: "#{baseurl}hero/others",
  theme: "#{baseurl}zhu-ti-gui-ze-xi-tong",
  old_generation: "#{baseurl}jiu-shi-dai",
  dark: "#{baseurl}an-hei-zhen-fa",
  spirit: "#{baseurl}jing-ling",
  new_school: "#{baseurl}xin-shuang-xue-pai"
}

rule = {}
links.each do |key, link|
  html = open( link )
  doc = Nokogiri::HTML( html.read )
  doc.encoding = 'utf-8'

  text = doc.css("#sites-canvas-main-content").to_s.gsub(%r{</?[^>]+?>}, '')
  lines = text.split("\n")

  spells = lines.map do |line|
    md = /^([^／，「」]+)／([^／「」]+)／([^／，「」]{4})，([^／]+)$/.match(line)
    unless md.nil?
      {
        name: md[1],
        combination: md[2],
        category: md[3],
        effect: md[4]
      }
    end
  end.compact

  abilities = lines.map do |line|
    md = /^([^／，「」]+)／([^／，「」]{4})，([^／]+)$/.match(line)
    unless md.nil?
      {
        name: md[1],
        category: md[2],
        effect: md[3]
      }
    end
  end.compact

  title = doc.css("#sites-page-title").text

  rule = rule.merge({
    key => {
      name: title,
      content: {
        ability: abilities,
        spell: spells
      }
    }
  })

  puts "done with #{title}"
end

File.open("rule.json", "w").puts JSON.pretty_generate(rule)
