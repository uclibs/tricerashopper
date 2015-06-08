namespace :qc do
  namespace :order do
    desc "Run jobs for oldest 10% of index"
    task :oldest_10 => :environment do
      SierraIndexHelper.oldest_10_percent('o').each do |record|
        Resque.enqueue(OrderRecordQc, record.record_num)
      end
    end

    desc "Run jobs for all of index"
    task :all => :environment do
      SierraIndexHelper.all_records('o').each do |record|
        Resque.enqueue(OrderRecordQc, record.record_num)
      end
    end
  end
end
