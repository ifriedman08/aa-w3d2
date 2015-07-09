
class User
  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
        ;
    SQL

    User.new(result.first)
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id;
    SQL

    User.new(result.first)
  end

  def authored_questions
    Question::find_by_author_id(@id)
  end

  def authored_replies
    Reply::find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow::followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    QuestionsDatabase.get_first_value(<<-SQL, id: @id)
      SELECT
        CAST(COUNT(ql.question_id) AS FLOAT)/COUNT(DISTINCT(q.id)) karma
      FROM
        questions q
      LEFT OUTER JOIN
        question_likes ql ON ql.question_id = q.id
      WHERE
        q.user_id = :id
      SQL

  end
end
