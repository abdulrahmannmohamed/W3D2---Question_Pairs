require_relative 'QuestionsDatabase'
require_relative 'model_base'

class Reply < ModelBase
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.table
    'replies'
  end


  def self.find_by_parent_id(parent_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
      SQL

    replies.map{|reply| Reply.new(reply) }
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@user_id)

  end

  def question
    Question.find_by_id(@question_id)

  end

  def parent_reply
    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end

  def save
    if @id
      update_database
    else
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body)
        INSERT INTO
          replies (question_id, parent_reply_id, user_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end

  end

  def update_database
    raise "Not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body, @id)
      UPDATE
        replies
      SET
        question_id = ?, parent_reply_id = ?, @user_id = ?, @body = ?
      WHERE
        id = ?
    SQL
  end


end
