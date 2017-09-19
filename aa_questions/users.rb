require_relative 'QuestionsDatabase'
require_relative 'model_base'

class User < ModelBase
  attr_accessor :id, :fname, :lname

  def self.table
    'users'
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(DISTINCT questions.id) / CAST(COUNT(question_likes.question_id) AS FLOAT) AS karma
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON question_likes.question_id = questions.id
    WHERE
      questions.author_id = ?;
    SQL

    return karma.first['karma'] || 0
  end

  def save
    if @id
      update_database
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          users(fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  def update_database
    raise "Not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end

end
