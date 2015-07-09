class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def initialize(options={})
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id;
    SQL

    Reply.new(result.first)
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = :user_id;
    SQL

    result.map {|result| Reply.new(result)}
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = :question_id;
    SQL

    result.map{|result| Reply.new(result)}
  end

  def author
    User::find_by_id(@user_id)
  end

  def question
    Question::find_by_id(@question_id)
  end

  def parent_reply
    return [] if @parent_reply_id == nil
    Reply::find_by_id(@parent_reply_id)
  end

  def child_replies
  result = QuestionsDatabase.instance.execute(<<-SQL, id: @id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_reply_id = :id;
    SQL
  result.map{|result| Reply.new(result)}
  end

end
