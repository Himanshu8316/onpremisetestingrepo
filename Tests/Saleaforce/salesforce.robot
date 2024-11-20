*** Settings ***

Documentation         New test suite
Library               QForce
Library               QWeb
Suite Setup           Open Browser                about:blank            chrome
Suite Teardown        Close All Browsers

*** Variables ***
${browser}            chrome
${username}           hsharma+1008202402@copado.com.dev1-sfp
${password}           crttest1234
${login_url}          https://speed-ruby-12652.scratch.my.salesforce.com/
${MY_SECRET}          6WPDNQX3XNRVO432MYPCF53XPPUAXKZE
*** Test Cases ***
Login to Salesforce
    GoTo              ${login_url}

    VerifyText        Username
    TypeText          Username                    ${username}
    TypeSecret        Password                    ${password}
    ClickText         Log In to Sandbox

    ${MFA_needed}=    Run Keyword And Return Status                      Should Not Be Equal             ${None}    ${MY_SECRET}
    Log To Console    ${MFA_needed} # When given ${MFA_needed} is true, see Log to Console keyword result
    IF                ${MFA_needed}
        ${mfa_code}=                              GetOTP                 ${username}     ${MY_SECRET}
        TypeSecret    Verification Code           ${mfa_code}
        ClickText     Verify
    END
    VerifyText        Seller Home

Logout
    VerifyText        Seller Home
    ClickItem         User
    ClickText         Log Out
    VerifyText        Username