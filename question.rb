require_relative 'table'

class Question < Table
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map {|result| Question.new(result)}
  end

  attr_accessor :id, :title, :body, :user_id

  def initialize(options={})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id;
    SQL

    Question.new(result.first)
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = :author_id
    SQL

    result.map {|result| Question.new(result)}
  end

  def author
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id: @user_id)
    SELECT
      *
    FROM
      users
    WHERE
      id = :author_id
    SQL
  end

  def replies
    Reply::find_by_question_id(@id)
  end

  def followers
    QuestionFollow::followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollow::most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question(@id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  # def save
  #   # debugger
  #   saved = @id.nil?
  #   if saved
  #     QuestionsDatabase.instance.execute(<<-SQL, title: @title, body: @body, user_id: @user_id)
  #     INSERT INTO
  #       questions (title, body, user_id)
  #     VALUES
  #       (:title, :body, :user_id)
  #     SQL
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, id: @id, title: @title, body: @body, user_id: @user_id)
  #     UPDATE
  #       questions q
  #     SET  (title, body, user_id)
  #       = (:title, :body, :user_id)
  #     WHERE
  #       :id = q.id
  #     SQL
  #   end
  # end
end
