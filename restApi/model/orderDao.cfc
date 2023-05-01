<cfcomponent hint="Order table releted queries performed here" displayName="OrderDao">
    <cffunction  name="init" hint="Constrictor for OrderDao">
        <cfargument  name="datasource" default="#application.datasource#" type="string" />
        <cfset this.datasource = ARGUMENTS.datasource>
        <cfreturn this>
    </cffunction>

    <cffunction  name="createOrder" access="public" output="false" hint="create order" returntype="struct">
        <cfargument  name="orderDetail" required="true" type="struct" />

        <cfset local.orderNumber = "ORD" & randRange(-100000, 100000, "CFMX_COMPAT")>
        <cfset local.response = {}>
        <cfquery datasource="#this.datasource#" result="orderResult">
            INSERT INTO RideShare_API_Orders (order_number, order_description, plate, dl_number, internal_order_id, external_order_id, status_id, created_at, active) 
            values (
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
          <cfset response["orderNumber"] = local.orderNumber> 
          <cfreturn local.response>
    </cffunction>

    <cffunction  name="orderStatus" access="public" output="false" hint="create order" returntype="query"> 
        <cfargument name="orderId" required="true" type="string" />
        <cfquery datasource="#this.datasource#" name="local.orderStatus">
            select s.id, s.title, o.order_number from RideShare_API_Orders o 
            inner join RideShare_API_Status s on o.status_id = s.id 
            where order_id = <cfqueryparam value="#arguments.orderId#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn local.orderStatus>
    </cffunction>

    <cffunction  name="getFile" access="public" output="false" hint="create order" returntype="query">
        <cfargument name="orderId" required="true" type="string" />
        <cfquery datasource="#application.datasource#" name="local.getFile">
            SELECT * FROM RideShare_API_Orders where external_order_id = 
        <cfqueryparam value="#arguments.orderId#" cfSqlType="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn local.getFile>
    </cffunction>

</cfcomponent>