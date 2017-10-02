<%@ include file="/init.jsp"%>

<div class="container-fluid-1280">
	<liferay-ui:success key="success" message="Users created successfully" />
	<liferay-ui:error key="group-friendly-url-error" message="The username has already been used for the name of a site or an organization. These names must be unique." />

	<%@ include file="/command_select.jspf"%>

	<portlet:actionURL name="<%= LDFPortletKeys.USERS %>" var="userEditURL">
		<portlet:param name="<%= LDFPortletKeys.MODE %>" value="<%=LDFPortletKeys.MODE_USERS %>" />
		<portlet:param name="redirect" value="<%=portletURL.toString()%>" />
	</portlet:actionURL>

	<aui:fieldset-group markupView="lexicon">
		<aui:fieldset>
            <div class="entry-title form-group">
                <h1>Create Users&nbsp;&nbsp;
                    <a aria-expanded="false" class="collapse-icon collapsed icon-question-sign" data-toggle="collapse" href="#navPillsCollapse0">
                    </a>
                </h1>
            </div>

            <div class="collapsed collapse" id="navPillsCollapse0" aria-expanded="false" >
                <blockquote class="blockquote-info">
                    <small>Example</small>
                    <p>if you enter the values <code>3</code> and <code>user</code> the portlet will create three blank sites: <code>user1</code>, <code>user2</code>, and <code>user3</code>.<p>
                </blockquote>

                <ul>
                    <li>You must be signed in as an administrator in order to create users</li>
                    <li>The counter always starts at <code>1</code></li>
					<li>Email addresses will be the base screenName + "@liferay.com"</li>
					<li>Passwords are set to <code>test</code></li>
					<li>Users' first names will be the base screenName you input</li>
					<li>Users' last names will be the counter</li>
                </ul>

                <h3>Creating Large Batches of Users</h3>
                <ul>
                    <li>If the number of users is large (over <code>100</code>), go to <i>Control Panel -> Server Administration -> Log Levels -> Add Category</i>, and add <code>com.liferay.support.tools</code> and set to <code>INFO</code> to track progress (batches of 10%)</li>
                    <li>It may take some time (even for the logs to show) to create a large number of users, and the page will hang until the process is complete; you can query the database if you are uncertain of the progress</li>
                </ul>
            </div>

			<%
			String numberOfusersLabel= "Enter the number of users you would like to create";
			String baseScreenNameLabel= "Enter the base screenName for the users (i.e. newUser, testUser, user)";
            String baseDomainLabel = "Domain name here. (i.e. liferay.com, gmail.com). If no domain specified, liferay.com will be used.";

			%>

			<aui:form action="<%= userEditURL %>" method="post" name="fm" >
				<div class="row">
					<aui:fieldset cssClass="col-md-6">
						<aui:input name="numberOfusers" label="<%= numberOfusersLabel %>" >
							<aui:validator name="digits" />
							<aui:validator name="min">1</aui:validator>
							<aui:validator name="required" />
						</aui:input>
					</aui:fieldset>
				</div>
                <div class="row">
                    <aui:fieldset cssClass="col-md-6">
                        <aui:input name="baseScreenName" label="<%= baseScreenNameLabel %>" >
                            <aui:validator name="required" />
                        </aui:input>
                    </aui:fieldset>
                    <aui:fieldset cssClass="col-md-6">
                        <aui:input name="baseDomain" label="<%= baseDomainLabel %>" value="liferay.com"/>
                    </aui:fieldset>
                </div>

				<%
				String defaultOption = "(None)";

				//Organization
				List<Organization> organizations = OrganizationLocalServiceUtil.getOrganizations(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
				List<Group> groups = GroupLocalServiceUtil.getGroups(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
				List<Role> roles = RoleLocalServiceUtil.getRoles(company.getCompanyId());
				List<UserGroup> userGroups = UserGroupLocalServiceUtil.getUserGroups(company.getCompanyId());
				Role defaultRole = RoleLocalServiceUtil.getRole(company.getCompanyId(), RoleConstants.USER);
				String scopeGroupdId = String.valueOf(themeDisplay.getScopeGroupId());

				String organizationLabel = "Select organizations to assign the users to";
				String groupLabel = "Select sites to assign the users to";
				String roleLabel = "Select roles to assign the users to";
				String roleHelpMessage = "Organization and site roles cannot be assigned unless users are assigned to an organization or site.";
				String userGroupsLabel = "Select user groups to assign the users to";
				String passwordLabel = "Enter password";
				String maleLabel = "Genger (checked is male)";
				String fakerEnableLabel = "Use Real names for First and Last name (Generated by Faker)";
				String localesLabel = "Locale for Autogenerated names";
				%>

				<aui:a href="#inputOptions" cssClass="collapse-icon collapsed icon-angle-down" title="Option" aria-expanded="false" data-toggle="collapse" >&nbsp;&nbsp;option</aui:a>
				<div class="collapsed collapse" id="inputOptions" aria-expanded="false" >
					<div class="row">
						<aui:fieldset cssClass="col-md-6">
							<aui:select name="organizations" label="<%= organizationLabel %>" multiple="<%= true %>" >
								<%
								for (Organization organization : organizations) {
								%>
									<aui:option label="<%= organization.getName() %>" value="<%= organization.getOrganizationId() %>"/>
								<%
								}
								%>
							</aui:select>
							<aui:select name="groups" label="<%= groupLabel %>"  multiple="<%= true %>">
								<%
								for (Group group : groups) {
									if (group.isSite() && !group.getDescriptiveName().equals("Control Panel")) {
								%>
										<aui:option label="<%= group.getDescriptiveName() %>" value="<%= group.getGroupId() %>"/>
								<%
									}
								}
								%>
							</aui:select>
							<aui:select name="roles" label="<%= roleLabel %>" helpMessage="<%= roleHelpMessage %>"  multiple="<%= true %>" >
								<%
								for (Role role : roles) {
								%>
									<aui:option label="<%= role.getDescriptiveName() %>" value="<%= role.getPrimaryKey() %>"/>
								<%
								}
								%>
							</aui:select>
							<aui:select name="userGroups" label="<%= userGroupsLabel %>"  multiple="<%= true %>" >
								<%
								for (UserGroup userGroup : userGroups) {
								%>
									<aui:option label="<%= userGroup.getName() %>" value="<%= userGroup.getUserGroupId() %>"/>
								<%
								}
								%>
							</aui:select>
						</aui:fieldset>
						<aui:fieldset cssClass="col-md-6">
							<aui:input name="password" label="<%= passwordLabel %>" value="test"/>
							<aui:input name="male" type="toggle-switch" label="<%= maleLabel %>" value="<%= true %>"/>
							<aui:input name="fakerEnable" type="toggle-switch" label="<%= fakerEnableLabel %>" value="<%= false %>"/>
							<%
							Set<Locale> locales = LanguageUtil.getAvailableLocales(themeDisplay.getSiteGroupId());
							//TODO : Locale need to be filtered for only available
							//List<Locale> locales = UserDataService.getFakerAvailableLocales(orgLocales);

							%>
							<aui:select name="locale" label="<%= localesLabel %>" multiple="<%= false %>">
								<%
								for (Locale availableLocale : locales) {
								%>
									<aui:option label="<%= availableLocale.getDisplayName(locale) %>" value="<%= availableLocale.getLanguage() %>"
									selected="<%= availableLocale.toString().equals(LocaleUtil.getDefault().toString()) %>" />
								<%
								}
								%>
							</aui:select>
 						</aui:fieldset>
					</div>
				</div>
				<aui:button-row>
					<aui:button type="submit" value="Run" cssClass="btn-lg btn-block btn-primary" id="processStart"/>
				</aui:button-row>
			</aui:form>
			<liferay-ui:upload-progress
				id="<%= progressId %>"
				message="creating..."
			/>
		</aui:fieldset>
	</aui:fieldset-group>
</div>

<aui:script use="aui-base">
	var processStart = A.one('#<portlet:namespace />processStart');

	processStart.on(
	    'click',
	    function() {
	    	event.preventDefault();
			<%= progressId %>.startProgress();
			submitForm(document.<portlet:namespace />fm);
	    }
	);
</aui:script>

<portlet:resourceURL id="<%=LDFPortletKeys.CMD_ROLELIST %>" var="roleListURL" />

<script type="text/html" id="<portlet:namespace />roles_options">
    <option value="<@= roleId @>" data-role-type="<@= type @>" ><@= name @></option>
</script>

<aui:script use="aui-base">
	function <portlet:namespace />updateRoles() {
		var data = Liferay.Util.ns(
			'<portlet:namespace />',
			{
				<%=Constants.CMD %>: '<%=RoleMVCResourceCommand.CMD_ROLELIST%>',
				isSitesSelected: (null==$('#<portlet:namespace />groups').val())?false:true,
				isOrganizationSelected: (null==$('#<portlet:namespace />organizations').val())?false:true
			}
		);

		$.ajax(
			'<%= roleListURL.toString() %>',
			{
				data: data,
				success: function(data) {

					//Load Template
					var tmpl = _.template($('#<portlet:namespace />roles_options').html());
					var listAll = "";
					_.map(data,function(n) {
						listAll +=
						tmpl(
						  {
							name:(n.name) ? _.escape(n.name) : "",
							roleId:(n.roleId) ? _.escape(n.roleId) : "",
							type:(n.type) ? _.escape(n.type) : ""
						  }
						);
					});
					var pageObj = $('#<portlet:namespace />roles')
					pageObj.empty();
					pageObj.append(listAll);
				}
			}
		);
	}

	$('#<portlet:namespace />organizations, #<portlet:namespace />groups').on(
		'change',
		function(event) {
			<portlet:namespace />updateRoles();
		}
	);

	$( function() {
		//Initialize role options
		<portlet:namespace />updateRoles();
	});
</aui:script>