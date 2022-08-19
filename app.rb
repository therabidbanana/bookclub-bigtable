# 0. Accept Reads and Writes
# 1. Pass writes to memtable
# 2. Every X writes, dump SSTable 
# 3. Reads check memtable then sstables
# 4. Compaction process (manual)

require 'json'

class NotFound < StandardError
end

class Memtable
  def initialize
    @fake_avl_tree = {}
  end

  def write(key, val)
    @fake_avl_tree[key] = val
  end

  def read(key)
    if @fake_avl_tree.has_key?(key)
      @fake_avl_tree.fetch(key)
    else
      raise NotFound
    end
  end

  def full?
    @fake_avl_tree.keys.count > 2
  end

  def to_json
    JSON.dump(@fake_avl_tree)
  end
end

class SSTable
  def self.from_file(dir, table_file)
    parsed = JSON.parse(File.read(File.join(dir, table_file)))
    puts "Loaded sstable #{table_file}"
    new(parsed)
  end

  def self.write_out(dir, table_data)
    timestamp = Time.now.to_s
    puts "Dumping new SSTable #{timestamp}.json"
    File.write("#{dir}/#{timestamp}.json", table_data.to_json)
  end

  def initialize(data_hash)
    @data = data_hash
  end

  def read(key)
    if @data.has_key?(key)
      @data.fetch(key)
    else
      raise NotFound
    end
  end
end

class BookclubBigtable

  def initialize(db_path = "db")
    @memtable = Memtable.new
    @db_path = db_path
    Dir.mkdir(db_path)
  rescue Errno::EEXIST => e
    "DB already exists"
  end

  def write(key, val)
    @memtable.write(key, val)
    if @memtable.full?
      old = @memtable
      @memtable = Memtable.new
      SSTable.write_out(@db_path, old)
    end
  end

  def read(key)
    begin
      return @memtable.read(key)
    rescue NotFound => e
      filenames = Dir.entries(@db_path).reject{ |f| f =~ /^\./ }.sort.reverse
      value = NotFound
      filenames.each do |table|
        begin
          value = SSTable.from_file(@db_path, table).read(key)
          break
        rescue NotFound => e
        end
      end
      if value != NotFound
        value
      else
        raise value
      end
    end
  end
end

require 'pry'
$db = BookclubBigtable.new

binding.pry
