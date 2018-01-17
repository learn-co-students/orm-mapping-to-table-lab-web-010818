#build:
#1. a class method on the Student class that creates the students table in the database
#2. a method that can drop that table and a method
#3. #save, that can save the data concerning an individual student object to the database

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize (id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    #save student attributes to table
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    #save assigned id to instance
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    #create a new instance of the student class
    student = self.new(name, grade)
    #save the new instance to the database
    student.save
    student
  end
end
