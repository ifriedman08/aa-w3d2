require_relative 'util'

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def initialize(options={})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id;
    SQL
    QuestionLike.new(result.first)
  end

  def self.likers_for_question(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_id: question_id)
      SELECT
        u.*
      FROM
        question_likes ql
      JOIN
        users u ON u.id = ql.user_id
      WHERE
        ql.question_id = :q_id
      SQL
      result.map {|user| User.new(user)}
  end

  def self.num_likes_for_question(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, q_id: question_id)
      SELECT
        COUNT(question_likes.user_id)
      FROM
        question_likes
      WHERE
        :q_id = question_likes.question_id
      SQL
    result.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, u_id: user_id)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        question_likes ql ON ql.question_id = q.id
      WHERE
        ql.user_id = :u_id
      SQL
    result.map{|result| Question.new(result)}
  end

  def self.most_liked_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        (SELECT
          COUNT(ql.user_id) count, ql.question_id
        FROM
          question_likes ql
        GROUP BY
          ql.question_id
          ) ql_order on ql_order.question_id = q.id
      ORDER BY
        count DESC
      LIMIT :n
      SQL
    result.map{|q_hash| Question.new(q_hash)}
  end
end
