#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

#
# Check CPU Steal
#
class CheckSteal < Sensu::Plugin::Check::CLI
  option :warn,
         short: '-w WARN',
         proc: proc(&:to_f),
         default: 10

  option :crit,
         short: '-c CRIT',
         proc: proc(&:to_f),
         default: 15

  def stats
    info = File.foreach('/proc/stat').first.split(/\s+/)
    info.shift
    info.map(&:to_f)
  end

  def run
    stats_now = stats
    sleep 5
    stats_later = stats
    total_diff = stats_now.inject(:+) - stats_later.inject(:+)
    steal_diff = stats_now[7] - stats_later[7]
    steal_pct = steal_diff / total_diff * 100

    message "Steal Percentage: #{steal_pct}"

    critical if steal_pct > config[:crit]
    warning if steal_pct > config[:warn]
    ok
  end
end
