require 'byebug'
require_relative 'util'


class Table

  def initialize
  end

  def save
    arg_hash = {}
    inst_var = self.instance_variables

    inst_var.drop(1).each do |var|
      arg_hash[var[1..-1].to_sym] = instance_variable_get(var)
    end

    cols = "(#{arg_hash.keys.join(', ')})"

    vals = "(#{arg_hash.values.join(', ')})"



    saved = @id.nil?

    if saved
      # debugger
      QuestionsDatabase.instance.execute(<<-SQL, cols: cols)
      INSERT INTO
        questions (#{arg_hash.keys.join(', ')})
      VALUES
        #{vals}
      SQL
    end
  #   else
  # #     QuestionsDatabase.instance.execute(<<-SQL, id: @id, title: @title, body: @body, user_id: @user_id)
  # #     UPDATE
  # #       questions q
  # #     SET  (title, body, user_id)
  # #       = (:title, :body, :user_id)
  # #     WHERE
  # #       :id = q.id
  # #     SQL
  #   end
  end
end

#
# [].length
# [].send(:length)
#
# instance_variable_get(:@var)
