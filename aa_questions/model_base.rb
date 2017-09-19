class ModelBase

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM #{self.table}")
    data.map {|datum| self.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        id = ?
    SQL

    self.new(data.first)
  end

  # def save
  #   instance_vars = self.instance_variables.rotate[0..-2].join(", ")
  #   column_names = self.instance_variables.rotate[0..-2].join(", ").delete("@")
  #   QuestionsDatabase.instance.execute(<<-SQL, instance_vars)
  #     INSERT INTO
  #       #{self.class.table} ( #{column_names} )
  #     VALUES
  #       (?, ?, ?, ?)
  #   SQL
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end

end
