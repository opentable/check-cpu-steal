#
# Stat collection and calculation
#
class CpuStats
  CLASSES = [:user, :nice, :system, :idle, :iowait, :irq,
             :softirq, :steal, :guest, :guest_nice].freeze

  def initialize(sleep_time = 5)
    @now = stats
    sleep sleep_time
    @later = stats
    @now[:total] = @now.values.inject(:+)
    @later[:total] = @later.values.inject(:+)
  end

  def read_proc(file = '/proc/stat')
    File.foreach(file).first
  end

  def stats
    info = read_proc
    stats = info.split(/\s+/)
    stats.shift
    stats.map(&:to_f)
    Hash[CLASSES.zip(stats)]
  end

  def get_stat_diff(stat_name)
    @later[stat_name] - @now[stat_name]
  end

  def get_stat_pct(stat_name)
    get_stat_diff(stat_name) / get_stat_diff(:total)
  end
end
