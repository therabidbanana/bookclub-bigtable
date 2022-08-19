# Usage

Install pry and then run the file. $db global will be the database:

```
$ gem install pry
$ ruby app.rb
```

```
[2] pry(main)> $db.read("2")
Loaded sstable 2022-08-19 13:26:08 -0700.json
=> "shoe"
[3] pry(main)> $db.read("2")
Loaded sstable 2022-08-19 13:26:08 -0700.json
=> "shoe"
[4] pry(main)> $db.write("1", "fun")
=> nil
[5] pry(main)> $db.write("2", "flew")
=> nil
[6] pry(main)> $db.write("4", "fine")
Dumping new SSTable 2022-08-19 13:29:20 -0700.json
=> 33
[7] pry(main)> $db.read("2")
Loaded sstable 2022-08-19 13:29:20 -0700.json
=> "flew"
[8] pry(main)> $db.read("3")
Loaded sstable 2022-08-19 13:29:20 -0700.json
Loaded sstable 2022-08-19 13:26:08 -0700.json
=> "tree"
[9] pry(main)> exit
```
