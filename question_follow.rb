require_relative 'util'


class QuestionFollow
  def self.followers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        u.*
      FROM
        question_follows q
      JOIN
        users u ON u.id = q.user_id
      WHERE
        question_id = :question_id
      SQL
    result.map{|u_hash| User.new(u_hash)}
  end

  def self.followed_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        question_follows qf ON qf.user_id = q.user_id
      WHERE
        qf.user_id = :user_id
      SQL
    result.map{|q_hash| Question.new(q_hash)}
  end

  def self.most_followed_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        (SELECT COUNT(qf.user_id) count_followers, qf.question_id
          FROM question_follows qf
          GROUP BY qf.question_id
          LIMIT :n
          ) top_qf ON q.id = top_qf.question_id
      ORDER BY
        count_followers
      SQL
    result.map{|q_hash| Question.new(q_hash)}
  end

end
