
<cfcomponent hint="Order specific data operations" displayname="order"> 
  
    <!--- User Details --->
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
  
  </cfcomponent>