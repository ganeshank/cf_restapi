<cfcomponent hint="Order specific data operations" displayname="orderService"> 
  
    <cffunction name="persistOrder" access="public" output="false" hint="persist order detail" returntype="struct">
      <cfargument name="orderDetail" required="true" type="struct" /> 
      
      <cfset var resObj = {}>
      <cfset local.result = application.orderDao.createOrder(arguments.orderDetail)>
        <cfif structKeyExists(local.result, 'orderId')>
          <cfset resObj["success"] = true>
          <cfset resObj["orderNumber"] = local.result.orderNumber>
          <cfset resObj["orderId"] = local.result.orderId>
          <cfset resObj["message"] = "Order is created successfully!!!">           
        <cfelse>
          <cfset resObj["success"] = false>
          <cfset resObj["message"] = "Order is failed"> 
        </cfif>
                 
      <cfreturn resObj>
    </cffunction>

    <cffunction name="getOrderStatus" access="public" output="false" hint="Get order status" returntype="struct">
      <cfargument name="orderId" required="true" type="string" />

      
      <cfset var resObj = {}>
      <cfset local.orderStatus = application.orderDao.orderStatus(arguments.orderId)>
      <cfif local.orderStatus.recordCount>
        <cfset local.orderStatusObj = {
          "orderId": arguments.orderId,
          "orderStatusId": local.orderStatus.id,
          "orderStatusName": local.orderStatus.title
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

    <cffunction  name="getFile" access="public" output="false" hint="Get student data" returntype="struct">
      <cfargument name="orderId" required="true" type="string" />

      <cfset local.response = {}>      
      <cfset local.directoryPath = expandPath('./restApi')&'/pdf'>
      <cfset local.getFile = application.orderDao.getFile(arguments.orderId)>
      <cfif getFile.recordcount GT 0> 
        <cfif (val(arguments.orderId) % 2) eq 0>
          <cffile  action="readbinary" file="#local.directoryPath#/abc.pdf" variable="getFile" />
         <cfset local.file = toBinary(ToBase64(toString(getFile)))>
         <cfset local.pdfFile = binaryEncode(local.file, "Base64")>
         <cfset local.response["success"] = true>
         <cfset local.response["message"] = "">          
         <cfset local.response["pdfFile"] = local.pdfFile>
        <cfelse>
         <cfset local.response["success"] = false>
         <cfset local.response["message"] = "file not found!">
        </cfif> 
      <cfelse>
        <cfset local.response["success"] = false>
        <cfset local.response["message"] = "Order id is invalid!">
      </cfif>
      <cfreturn local.response>
    </cffunction>
  
  </cfcomponent>



  