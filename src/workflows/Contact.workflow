<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Volunteer_Registration_Homeless_Hospitalized</fullName>
        <description>Volunteer Registration: Homeless/Hospitalized</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>volunteer@encircletogether.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Encircle_Volunteer_Templates/Registration_Homeless_Hospitalized</template>
    </alerts>
    <rules>
        <fullName>Volunteer Registration%3A Homeless%2FHospitalized</fullName>
        <actions>
            <name>Volunteer_Registration_Homeless_Hospitalized</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.Currently_Homeless__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Hospitalized_in_the_Last_6_Months__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send an email for volunteer applicants that have marked that they are homeless or have been hospitalized</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
