#
# CPU stat collection and calculation
#
class CpuStats

  os_family = File.read("/proc/version")
  if os_family.include? "ubuntu"
    CLASSES = [:user, :nice, :system, :idle, :iowait, :irq,
               :softirq, :steal, :guest, :guest_nice].freeze
  elsif os_family.include? "Red Hat"
    CLASSES = [:user, :nice, :system, :idle, :iowait, :irq,
               :softirq, :steal, :guest].freeze
  else
    raise 'this check does not support this os_family'
  end

  attr_reader :now, :later

  def collect(sleep_time = 5)
    @now = stats(read_proc)
    sleep sleep_time
    @later = stats(read_proc)
    @now[:total] = @now.values.inject(:+)
    @later[:total] = @later.values.inject(:+)
  end

  def read_proc(file = '/proc/stat')
    File.foreach(file).first
  end

  def stats(info)
    stats = info.split(/\s+/)
    stats.shift
    stats.map!(&:to_f)
    Hash[CLASSES.zip(stats)]
  end

  def stat_diff(stat_name)
    @later[stat_name] - @now[stat_name]
  end

  def stat_pct(stat_name)
    stat_diff(stat_name) / stat_diff(:total)
  end
end
