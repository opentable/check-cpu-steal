require 'spec_helper'
require 'check_cpu_steal/cpu_stats'

RSpec.describe CpuStats do
  it 'Parses a valid /proc/stat' do
    stats = CpuStats.new
    expectation = { user: 1.0,
                    nice: 2.0,
                    system: 3.0,
                    idle: 4.0,
                    iowait: 5.0,
                    irq: 6.0,
                    softirq: 7.0,
                    steal: 8.0,
                    guest: 9.0,
                    guest_nice: 10.0 }
    expect(stats.stats('cpu 1 2 3 4 5 6 7 8 9 10')).to eq(expectation)
  end

  it 'Calls read_proc twice when collecting' do
    stats = CpuStats.new
    allow(stats).to receive(:read_proc).and_return(
      'cpu 1 2 3 4 5 6 7 8 9 0',
      'cpu 11 12 13 14 15 16 17 18 19 20'
    )
    expect(stats).to receive(:read_proc).twice
    stats.collect(0)
  end

  it 'Calculates cpu totals' do
    stats = CpuStats.new
    allow(stats).to receive(:read_proc).and_return(
      'cpu 1 2 3 4 5 6 7 8 9 0',
      'cpu 11 12 13 14 15 16 17 18 19 20'
    )
    stats.collect(0)
    expect(stats.now[:total]).to eq(45)
    expect(stats.later[:total]).to eq(155)
  end
end
