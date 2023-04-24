
<cfcomponent hint="Order specific data operations" displayname="order"> 
  
    <cffunction name="persistOrder" access="public" output="false" hint="persist order detail" returntype="struct">
      <cfargument name="orderDetail" required="true" type="struct" />

      <cfset local.orderNumber = "ORD" & randRange(-100000, 100000, "CFMX_COMPAT")>
      
      <cfquery datasource="#application.datasource#" result="orderResult">
        INSERT INTO orders (order_id, order_number, order_description, plate, dl_number, internal_order_id, external_order_id, status_id, created_at, active) 
        values (
          <cfqueryparam value="#CreateUUID()#" cfsqltype="CF_SQL_VARCHAR">,
          <cfqueryparam value="#local.orderNumber#" cfsqltype="CF_SQL_VARCHAR">,
          <cfqueryparam value="#arguments.orderDetail.description#" cfsqltype="CF_SQL_VARCHAR">,
          <cfqueryparam value="#arguments.orderDetail.plate#" cfsqltype="CF_SQL_VARCHAR">,
          <cfqueryparam value="#arguments.orderDetail.dlNumber#" cfsqltype="CF_SQL_VARCHAR">,
          <cfqueryparam value="#arguments.orderDetail.internalOrderId#" cfsqltype="CF_SQL_INTEGER">,
          <cfqueryparam value="#arguments.orderDetail.externalOrderId#" cfsqltype="CF_SQL_INTEGER">,
          <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">,
          <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
          <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
        )
      </cfquery>

      <cfset var resObj = {}>
      <cfif orderResult.recordCount>
        <cfset resObj["success"] = true>
        <cfset resObj["orderNumber"] = local.orderNumber>
        <cfset resObj["message"] = "Order is created successfully!!!"> 
      <cfelse>
        <cfset resObj["success"] = false>
        <cfset resObj["message"] = "Order is failed"> 
      </cfif>
           
      <cfreturn resObj>
    </cffunction>

    <cffunction name="getOrderStatus" access="public" output="false" hint="Get order status" returntype="struct">
      <cfargument name="orderId" required="true" type="string" />

      <cfquery datasource="#application.datasource#" name="orderStatus">
        select s.id, s.title from orders o 
        inner join Status s on o.status_id = s.id 
        where order_id = <cfqueryparam value="#arguments.orderId#" cfsqltype="CF_SQL_VARCHAR">
      </cfquery>

      <cfset var resObj = {}>
      <cfif orderStatus.recordCount>
        <cfset local.orderStatusObj = {
          "orderId": arguments.orderId,
          "orderStatusId": orderStatus.id,
          "orderStatusName": orderStatus.title
        }>
        <cfset resObj["success"] = true>
        <cfset resObj["data"] = local.orderStatusObj>
        <cfset resObj["message"] = "Order found"> 
      <cfelse>
        <cfset resObj["success"] = false>
        <cfset resObj["message"] = "Order id is not exist"> 
      </cfif>
           
      <cfreturn resObj>
    </cffunction>

    <cffunction name="getStudentData" access="public" output="false" hint="Get student data" returntype="struct">
      <cfargument  name="limit" type="any" required="true">
      <cfargument  name="offset" type="any" required="true">

      <cfset local.response = {}>
      <cfquery name="studentCount" datasource="#application.datasource#" >
          SELECT count(*) AS total FROM student 
      </cfquery>

      <cfquery name="getStudent" datasource="#application.datasource#" >
          SELECT * FROM student 
          order by id 
          OFFSET #arguments.offset# ROWS
          FETCH NEXT #arguments.limit# ROWS ONLY
      </cfquery>
      
      <cfset local.response.count = studentCount.total>
      <cfset local.response.items = getStudent>
      <cfreturn local.response>
    </cffunction>

    <cffunction name="QueryToArray" access="public" returntype="array" output="false"
      hint="This turns a query into an array of structures.">

      <!--- Define arguments. --->
      <cfargument name="Data" type="query" required="yes" />

      <cfscript>
        // Define the local scope.
        var LOCAL = StructNew();
        // Get the column names as an array.
        LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
        // Create an array that will hold the query equivalent.
        LOCAL.QueryArray = ArrayNew( 1 );
        // Loop over the query.
        for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
          // Create a row structure.
          LOCAL.Row = StructNew();
          // Loop over the columns in this row.
          for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
            // Get a reference to the query column.
            LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
            // Store the query cell value into the struct by key.
            LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
          }
          // Add the structure to the query array.
          ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
        }
        // Return the array equivalent.
        return( LOCAL.QueryArray );
      </cfscript>
    </cffunction> 

    <cffunction  name="getFile" access="public" output="false" hint="Get student data" returntype="struct">
      <cfargument name="orderId" required="true" type="string" />
      <cfset local.response = {}>

      <cfquery datasource="#application.datasource#" name="getFile">
        SELECT order_count FROM orders where order_id = 
        <cfqueryparam value="#arguments.orderId#" cfSqlType="CF_SQL_VARCHAR">
      </cfquery>

      <cfif getFile.recordcount GT 0> 
         <cfif (getFile.order_count % 2) eq 0>
          <cfset local.response["success"] = true>
          <cfset local.response["message"] = "">
          <cffile  action="readbinary" file="C:\ColdFusion2018\cfusion\wwwroot\cf_restapi\abc.pdf" variable="getFile" />
          <cfset local.file = toBinary(ToBase64(toString(getFile)))>
          <cfset local.pdfFile = binaryEncode(local.file, "Base64")>          
          <cfset local.response["pdfFile"] = local.pdfFile>
         <cfelse>
          <cfset local.response["success"] = false>
          <cfset local.response["message"] = "file not found">
         </cfif>       
        
      </cfif>
      <cfreturn local.response>
    </cffunction>
  
  </cfcomponent>