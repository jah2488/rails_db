module RailsDb
  module Adapters

    class BaseAdapter
      extend ::RailsDb::Connection

      MULTI_STATEMENT_HELP_TEXT = "EXPERIMENTAL: You can import only file with SQL statements separated by ';'. Each new statement must start from new line."

      def self.execute(sql)
        t0 = Time.now
        connection.execute(sql)
        Time.now - t0
      end

      def self.exec_query(sql, log = true)
        t0 = Time.now
        Rails.logger.debug "--> Executing: #{sql}" if log
        results = connection.exec_query(sql)
        execution_time = Time.now - t0
        [results, execution_time]
      end

      def self.adapter_name
        'base'
      end

      def self.mime
        'text/x-sql'
      end

      def self.truncate(table_name)
        execute("TRUNCATE TABLE #{table_name};")
      end

      def self.delete(table_name, pk_name, pk_id)
        execute("DELETE FROM #{table_name} WHERE #{pk_name} = #{pk_id};")
      end

      private

      def self.multiple_execute(sql, divider = ";\n")
        sql.split(divider).each do |statement|
          connection.execute(statement)
        end
      end

    end

  end
end