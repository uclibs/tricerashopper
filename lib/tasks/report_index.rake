namespace :index do
  desc "Delete all index records"
  task :delete_all => [:delete_bib, :delete_item, :delete_checkin, :delete_order] do
  end

  desc "Update all index records"
  task :update_all => [:update_bib, :update_item, :update_checkin, :update_order] do
  end

  desc "Build all index records"
  task :build_all => [:build_bib, :build_item, :build_checkin, :build_order] do
  end


  desc "Delete all bib index records"
  task :delete_bib => :environment do
    SierraIndexHelper.delete_all('b')
  end

  desc "Retrieve new bib index records"
  task :update_bib => :environment do
    SierraIndexHelper.update_index('b')
  end

  desc "Retrieve all bib index records"
  task :build_bib => :environment do
    SierraIndexHelper.build_index('b')
  end


  desc "Delete all item index records"
  task :delete_item => :environment do
    SierraIndexHelper.delete_all('i')
  end

  desc "Retrieve new item index records"
  task :update_item => :environment do
    SierraIndexHelper.update_index('i')
  end

  desc "Retrieve all item index records"
  task :build_item => :environment do
    SierraIndexHelper.build_index('i')
  end


  desc "Delete all checkin index records"
  task :delete_checkin => :environment do
    SierraIndexHelper.delete_all('c')
  end

  desc "Retrieve new checkin index records"
  task :update_checkin => :environment do
    SierraIndexHelper.update_index('c')
  end

  desc "Retrieve all checkin index records"
  task :build_checkin => :environment do
    SierraIndexHelper.build_index('c')
  end


  desc "Delete all order index records"
  task :delete_order => :environment do
    SierraIndexHelper.delete_all('o')
  end

  desc "Retrieve new order index records"
  task :update_order => :environment do
    SierraIndexHelper.update_index('o')
  end

  desc "Retrieve all order index records"
  task :build_order => :environment do
    SierraIndexHelper.build_index('o')
  end
end
