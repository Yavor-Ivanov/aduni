# xml-parse.tcl - grabs an xml file and inserts into database
# Written by Shyam Visweswaran at ADUni

# check if there is an incoming url and if there is one use
# it to grab the xml file, parse it and insert unique quotations
# into the table quotations

if { [ns_queryexists "url"] && [string length [ns_queryget "url"]] > 0 } {
    set url [ns_queryget "url"]
    if { [catch {ns_httpget $url} xml_document] } {
	return_complaint "Unable to connect to the URL. Go back and try again."
	return
    } else {
	set result [parse_all $xml_document]
	set page_content "
	<html>
	<head>
	<title>XML parsing results</title>
	</head>
	<body bgcolor=#ffffff>
	<blockquote>
	
	<table width=90%>
	<tr><td> <h2>XML parsing results</h2> </td>
	<td align=right> <a href=quotations.tcl>Quotations Home</a> | <a href=../>Home</a> </td></tr>
	</table>
	
	<hr>"
	
	foreach value [lindex $result 1] {
	    set quotation_id "[lindex [lindex $value 1] 1]"
	    set insertion_date "[lindex [lindex $value 2] 1]"
	    set author_name "[ns_dbquotevalue [string trim [lindex [lindex $value 3] 1]]]"
	    set category "[ns_dbquotevalue [string trim [lindex [lindex $value 4] 1]]]"
	    set quote "[ns_dbquotevalue [string trim [lindex [lindex $value 5] 1]]]"
	    
	    set sql_query "select * from quotations where upper(quote) = upper($quote) and upper(author_name) = upper($author_name) and rownum < 2"
	    set sql_insert "insert into quotes
	    (quotation_id, insertion_date, author_name, category, quote)
	    values
	    (quote_sequence.nextval, sysdate, $author_name, $category, $quote)"
	    
	    if { ![db_0or1row get_quotes $sql_query] } {
		append page_content "<li> <b>Inserting...</b> <i>$author_name</i> $quote"
		db_dml insert_quote $sql_insert
	    } else {
		append page_content "<li> <b>Skipping...</b> <i>$author_name</i> $quote"
	    }
	}
	
	append page_content "
	<p>
	<b>Done!</b>
	
	<hr>
	<address><a href=\"mailto:shyam@massmed.org\">shyam@massmed.org</a></address>
	</body>
	</html>"
	
	ns_return 200 text/html $page_content
    }
} else {
	set page_content "
	<html>
	<head>
	<title>XML Parsing</title>
	</head>
	<body bgcolor=#ffffff>
	<blockquote>
	
	<table width=90%>
	<tr><td> <h2>XML parsing</h2> </td>
	<td align=right> <a href=../>Home</a> </td></tr>
	</table>
	
	<hr>
	
	<form method=post action=xml-parse.tcl>
	Enter the complete URL of a XML document   
	<input type=text name=url size=50>
	<input type=submit value=\"Get and Parse\">
	</form>
	
	<hr>
	<address><a href=\"mailto:shyam@massmed.org\">shyam@massmed.org</a></address>
	</body>
	</html>"
	
	ns_return 200 text/html $page_content
}


