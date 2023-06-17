#*----------------------------------------------------*
#*     This program Elixir program will syntax        *
#*         highlighting your ABAP code                *
#*----------------------------------------------------*
#*         Creator    | Version |    Date             *
#*----------------------------------------------------*
#*                                                    *
#*     Carlos Fragoso |   1.0   |  26/05/2023         *
#*                                                    *
#* Modifications: Creation of exs, Module             *
#* Function Fun.Files, R.Sintaxis. Also Functions:    *
#* Fun.Files.appendFile, main_sintax Conform_css,     *
#* Conform_html. Also variables and Regex definitions *
#*----------------------------------------------------*
#*                                                    *
#*     Carlos Fragoso |   1.1   |  29/05/2023         *
#*                                                    *
#* Modifications: Creation of dynamic_span and        *
#* rest_content                                       *
#*----------------------------------------------------*
#*    Carlos Fragoso  |   1.2   |  09/06/2023         *
#*  Preserve the original indentation in the result   *
#*  Code adaptation in order to reduce no necesary    *
#* lines code. Also user text the text file to process*
#*  Actualization in keyword order                    *
#*----------------------------------------------------*
#*----------------------------------------------------*
#*    Carlos Fragoso  |   1.3   |  15/06/2023         *
#*       Parallelism and speedup calculation          *
#*----------------------------------------------------*

defmodule Fun.Files do
  def appendFile(file_path, cont, type)do #Creates txt file with user content
    cond do                               #Also Appends content to a existing file
      type == 'A' ->                      #Type == A will append, Type == C will create
        case File.open(file_path, [:append])do
          {:ok, file} ->
            IO.write(file, cont)
            File.close(file)
            {:ok, "Archivo creado: #{file_path}"}

          {:error, reason} ->
            {:error, reason}
        end

      type == 'C' ->
        case File.open(file_path, [:write])do
          {:ok, file} ->
            IO.write(file, cont)
            File.close(file)
            {:ok, "Archivo creado: #{file_path}"}

          {:error, reason} ->
            {:error2, reason}
        end
    end
  end
end

defmodule H.Syntax do
  #Regex to identify tokens or ABAP component code
  @regular_ex_kw     ~r/^\s*(?<keyword>MOVE|AUTHORITY-CHECK|FIELD-SYMBOL|ASSIGNING|IMPORTING|PERFORM|PARAMETERS|ENDMETHOD|ENDMODULE|STRUCTURE|CONDENSE|CONSTANTS|CONCATENATE|
UNASSIGN|ENDSELECT|ENDLOOP|ENDFORM|CONTINUE|CONVERT|DESCRIBE|ENDCASE|MESSAGE|COLLECT|COMMIT|COMPUTE|SELECTION|FUNCTION|ROLLBACK|REFRESH|REJECT|REPORT|RETURN|METHOD|MODIFY|MODULE|MULTIPLY|EXPORT|EXTRACT|APPEND|OBJECT|CATCH|CHECK|CLASS|CLEAR|CLOSE|OPTION|ENDTRY|UNION|UPDATE|VALUE|VALUES|VARYING|WHEN|WHILE|WITH|WRITE|WHERE|REPORT|
INCLUDE|GROUP|HAVING|IMPORT|INCLUDE|INITIAL|INNER|INTO|LEAVE|SELECT|SWITCH|DEFINE|DELETE|FROM|SUBMIT|ASSIGN|START|FORM|BREAK|CASE|NODES|ORDER|RAISE|READ|
ELSEIF|TYPE|TYPES|TABLE|AND|CALL|DATA|ELSE|ENDIF|END|EXIT|FETCH|FILTER|FINAL|FOR|LIKE|LOOP|NEW|NEXT|NOT|SET|SHIFT|SPLIT|STEP|SUM|TRY|TO|DO|AT|IF|NO|OF|ON|OR|IS)\b/
  @regular_ex_id    ~r/^(?i)<?[a-z][a-z0-9\_]*>?/
  @regular_ex_lit   ~r/^'.*'/
  @regular_ex_opera ~r/^[+\-*\/=:]/
  @regular_ex_delim  ~r/^[\(\)\[\]]/
  @regular_ex_comm   ~r/^".*(\r\n)?/
  @regular_ex_num    ~r/^\d+(\.\d+)?/
  @regular_ex_dot    ~r/^\.|\,|\@/
  @regular_ex_error ~r/^.*\.|.*/ #this one is used to figure out where to end Highling error

  @regex_lst [
    {@regular_ex_comm, "\"Comment\">"},
    {@regular_ex_kw, "\"key_word\">"},
    {@regular_ex_id, "\"Identifier\">"},
    {@regular_ex_num, "\"Number\">"},
    {@regular_ex_opera, "\"Operator\">"},
    {@regular_ex_lit, "\"Literal\">"},
    {@regular_ex_delim, "\"Delimiter\">"},
    {@regular_ex_dot, "\"Operator\">"},
    {@regular_ex_error, "\"Error\">"}
  ]

  defp conform_css(lv_css_path) do
    file_cont_css =
"/* Styles for syntax */
body {
  background-color: #f6f6f6;
  color: #000000;
  font-family: \"Courier New\", monospace;
  font-size: 14px;
  line-height: 1.4;
  padding: 20px;
}
span {
  margin-right: 0;
}
.key_word,.Identifier,.Literal,.Operator,
.Delimiter,.Comment,.Number,.Error {
  font-weight: bold;
}
.key_word{
  color: blue;
}
.Identifier {
  font-weight: normal;
  color: black;
}
.Literal {
  color: #00C800;
}
.Operator {
  color: #800080;
}
.Delimiter {
  color: #333333;
}
.Comment {
  color: #808080;
}
.Number {
  color: #0000FF;
}
.Error {
  color: #FF0000;
}
"
    Fun.Files.appendFile(lv_css_path,file_cont_css, 'C') #creates css with file_cont_css css code
  end

  defp conform_html(lv_html_path, lv_name_content) do
    file_cont_head_html =
"<!DOCTYPE html>
<html>
  <head>
  <meta charset=\"UTF-8\" />
  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
  <link rel=\"stylesheet\" type=\"text/css\" href=\" " <> "Style" <> ".CSS" <> "\" />
  </style>
  </head>
  <body> \n <PRE>
"
file_cont_end_html =
" </PRE> \n </body>
</html>"
      Fun.Files.appendFile(lv_html_path,file_cont_head_html,'C') #Creates first part from html

      {:ok, file_contents} = File.read(lv_name_content) #Get CONTENT.TXT data
      dynamic_span(lv_html_path, file_contents,@regex_lst) #Creates dynamic part from html (ABAP components)

      Fun.Files.appendFile(lv_html_path,file_cont_end_html, 'A') #Creates last part from html
  end

  defp dynamic_span(lv_html_path, content, regexlst) do

    [head | tail] = regexlst
    {regex,html_token} = head
    cond do
    #Recursive call in order to validate rest of code, function rest_content helps
    #to the creating of <span>s and deleting the actual component /^\s*\r\n/
    Regex.match?(~r/^\s*\r\n/, content) ->
      Fun.Files.appendFile(lv_html_path,
"
", 'A')
      dynamic_span(lv_html_path,Regex.replace(~r/^\s*\r\n/, content, "", global: false),@regex_lst)
    Regex.match?(~r/^\s/, content) ->
      Fun.Files.appendFile(lv_html_path," ", 'A')
      dynamic_span(lv_html_path,Regex.replace(~r/^\s/, content, "", global: false),@regex_lst)
    Regex.match?(regex, content) ->
      dynamic_span(lv_html_path,rest_content(lv_html_path,content,regex,html_token),@regex_lst)
    Regex.match?(~r/^$/, content) -> #Validation to know when content is empty
      "done"
    true ->
      dynamic_span(lv_html_path,content,tail)
    end
  end

  defp rest_content(lv_html_path,content, regex, html_token)do
    m = hd(Regex.scan(regex, content))
    [value | _] = m
    Fun.Files.appendFile(lv_html_path,"<span class="<>html_token<>value<>"</span>", 'A')

    rest = Regex.replace(regex, content, "", global: false)
    rest
  end

  def main_syntax(p_path) do
    #09/06/2023 changes in order to call function considerating path and filename
    #Conformation of final paths
    [filen, _] = Path.basename(p_path)
    |> String.split(".")
    lv_css_path = Path.dirname(p_path) <> "\/" <> "Style" <> ".CSS"
    lv_html_path = Path.dirname(p_path) <> "\/" <> filen <> ".HTML"
    lv_name_content = p_path

    #Function call
    conform_css(lv_css_path)
    conform_html(lv_html_path,lv_name_content)
  end

  defp make_list(lst, add, cores, remainder) do #Function to create a list listing the files per core or task
    case cores do
      1 ->
        {result, _} = Enum.split(lst, add + remainder)
        [result]
      _ ->
        {result, rest} = Enum.split(lst, add)
        [result | make_list(rest, add, cores - 1, remainder)]
    end
  end

  def parallel_syntax(p_path,cores)do # Function to get filenames, call make_list function and create a task.async using list returning from make_list
    p_path = String.replace(p_path,"\\","/")
    lst_files = Path.wildcard(p_path<>"*.txt")
        make_list(lst_files, div(length(lst_files),cores), cores, rem(length(lst_files),cores))
        |> Enum.map(&Task.async(fn -> do_parallel(&1) end))
        |> Enum.map(&Task.await(&1, :infinity))
  end

  defp do_parallel([]), do: :ok
  defp do_parallel(lst)do #in order to proccess each component from actual core
    [head | tail] = lst
    main_syntax(head)
    do_parallel(tail)
  end

  def run_sequential(p_path) do #iin order to proccess each component from directory in a sequential process
    p_path = String.replace(p_path,"\\","/")
    lst_files = Path.wildcard(p_path<>"*.txt")
    Enum.map(lst_files, fn element -> main_syntax(element) end)
  end

  def calc_speedup(p_path,cores)do #speedup calculation = sequential time / parallel time
        ((:timer.tc(fn -> H.Syntax.run_sequential(p_path) end) |> elem(0) |> Kernel./(1_000_000))) /
         (:timer.tc(fn -> H.Syntax.parallel_syntax(p_path,cores) end) |> elem(0) |> Kernel./(1_000_000))
  end
end
