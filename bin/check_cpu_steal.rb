#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'check_cpu_steal/cpu_stats'

#
# Check CPU Steal
#
class CheckCPUSteal < Sensu::Plugin::Check::CLI
  option :warn,
         short: '-w WARN',
         proc: proc(&:to_f),
         default: 10

  option :crit,
         short: '-c CRIT',
         proc: proc(&:to_f),
         default: 15

  def run
    stats = CpuStats.new
    stats.collect
    steal_pct = stats.stat_pct(:steal) * 100
    message "CPU Steal Percentage: #{steal_pct}"
    critical if steal_pct > config[:crit]
    warn if steal_pct > config[:warn]
    ok
  end
end
