require "pry"
class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil,name=nil,grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    #row [1, "Pat", 12]
    new_s=Student.new(row[0],row[1],row[2])
    # binding.pry

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * from students
      SQL
      all_s = DB[:conn].execute(sql)

      all_s.map do |student|
        self.new_from_db(student)
      end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * from students where name = ?
      SQL


      data = DB[:conn].execute(sql, name)[0]
      self.new_from_db(data)
      # binding.pry
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.count_all_students_in_grade_9
    sql =  <<-SQL
    SELECT * from students where grade = '9'

    SQL

    data = DB[:conn].execute(sql)
    data.map do |v|
      self.new_from_db(v)
    end
    # binding.pry
  end



  def self.students_below_12th_grade
    sql =  <<-SQL
    SELECT * from students where grade is NOT '12'
    SQL
    data = DB[:conn].execute(sql)
    data.map do |v|
      self.new_from_db(v)
    end
    # binding.pry
  end


  def self.first_X_students_in_grade_10(n)
    sql =  <<-SQL
    SELECT * from students where grade is '10' limit ?
    SQL
    data = DB[:conn].execute(sql,n)
    data.map do |v|
      self.new_from_db(v)
    end
    # binding.pry
  end


  def self.first_student_in_grade_10
    sql =  <<-SQL
    SELECT * from students where grade is '10' limit 1
    SQL
    data = DB[:conn].execute(sql)

    self.new_from_db(data[0])

  end


  def self.all_students_in_grade_X(n)
    sql =  <<-SQL
    SELECT * from students where grade is ?
    SQL
    data = DB[:conn].execute(sql,n)
    data.map do |v|
      self.new_from_db(v)
    end
    # binding.pry
  end





  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
