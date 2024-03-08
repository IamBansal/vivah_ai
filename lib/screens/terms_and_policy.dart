import 'package:flutter/material.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  final bool isTerms;
  const TermsAndPolicyScreen({super.key, required this.isTerms});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: Text(
          isTerms ? 'Terms and Services' : 'Privacy Policies',
          style: const TextStyle(
              color: Color(0xFF33201C),
              fontSize: 35)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(isTerms ? term : policy),
        ),
      ),
    ));
  }

  static String term = '''
Welcome to VIVAH_AI (“The Application”). These Terms and Conditions of Use (the “Terms”) are set out to protect the rights of the Application owners and users.

​

These Terms and our Privacy Policy and Cookie Policy constitute a legally binding agreement
made between the user or viewer of the application, whether personally or on behalf of an entity
(“you”) and Mikki Technologies Pvt Ltd (“the Company”), a Company incorporated under the
provisions of the companies act 1956, with its registered office at Jangid Complex, Mira Road (E)
Thane 401107 the owner of the website/ the Site (“we”, “us” or “our”), concerning your access to and/or use of the
VIVAH AI as well as any other media form, mobile website, media channel,
e-portal, or mobile application related, linked, or otherwise connected thereto (collectively, the
“Application”).


The Application is only to be used for your personal non-commercial use and information. Your use of
the Application and features of the Application shall be governed by these Terms and Conditions (hereinafter
&quot; Terms of Use &quot;) along with the Privacy Policy, Shipping Policy and Cancellation, Refund and
Return Policy (together &quot; Policies &quot;) as modified and amended from time to time.


By mere accessing or using the Application, you are acknowledging, without limitation or qualification,
to be bound by these Terms of Use and the Polices, whether you have read the same or
not. Accessing, Browsing or otherwise using the Application indicates your unconditional agreement to
all the Terms and Conditions in this agreement, so please read this agreement carefully before
proceeding. If you do not agree to any of the terms enumerated in the Terms of Use or the
Policies, please do not use the Application. You are responsible to ensure that your access to this Application
and material available on or through it are legal in each jurisdiction, in or through which you
access or view the Application or such material. By using the Application, you hereby acknowledge that you are
familiar with these Terms and any changes or modifications that may occur from time to time.
These Terms and Conditions are effective as of Mar 08, 2024.


Please read these Terms carefully in conjunction with the Privacy Policy, Cookie Policy, Content
Consent and other additional policies applicable to you, which may be changed from time to time by us, with or without notice to you. Such Privacy Policy, Cookie Policy, Content Consent and
other policies are made part of these Terms and Conditions of Use by this reference, and are in
addition to these Terms and Conditions of Use and are not exclusive.

​

Glossary

​

Account means a unique identifier, which is non-transferable and includes a username, password
and email address. It allows the user to access the Services, subject to its compliance with these
Terms, the User Agreement, the Privacy Policy, the Cookie Policy and other policies. 

Application means the app owned by the Mikki Technologies Pvt Ltd (and any successor or related locations designated by us).
Content includes all Text, Graphics, Design and Programming used on the Application.​​

User refers to any individual or entity that uses any aspect of the Applications.

You means the person who (or the entity on behalf of whom such person is acting) is agreeing to
these Terms and Conditions.

Services means the non-exclusive, non-transferable and non-sublicensable services as further
defined in the User Agreement, and that are made available or offered by the Mikki
Technologies Pvt Ltd through the Application, subject to your compliance with these Terms and
Conditions of Use, the Privacy Policy, the Cookie Policy, the Consent Content and other
policies, as well as payment of all applicable fees.


USER RESPONSIBILITIES AND PROHIBITED ACTIVITIES

Subject to the compliance with these Terms, we grant you a personal, non-exclusive, non-
transferable and limited privilege to enter and use the Application.

We expressly disclaim any responsibility or liability for any damages or losses,

         your computer/device name, your operating system, browser type and version,

         application version, operator name, screen size, CPU speed, and connection speed; 

         directly or indirectly, arising from the use of or reliance on any advice or output
         generated by AI on our Application.

No Service, in whole or in part, may be reproduced, sold, resold, visited, copied,
duplicated, or otherwise exploited for any commercial purpose without our express
written consent.

You must not misuse the Services and/or the Application. You may only use the Services and
the Application as permitted by these Terms and the applicable laws and regulations.

You must not access the Application through automated or non-human means e.g., page
scrapes, deep links, robots, whether through a bot, script or otherwise any automatic
device, program, algorithm, or through equivalent manual processes.

You must not use and/or access the Application, the Services, the Marks and/or any of the
Content for any purpose that is (i) prohibited by these Terms; or is (ii) illegal, malicious
or unauthorized; and/or (iii) to solicit the performance of any illegal activity or other
activity which infringes our rights or the rights of others.

You must not do anything that would slow down, overload or put an unreasonable and/or
disproportionate strain on the Application’s infrastructure, our systems or networks, and/or
any systems or networks connected to the Website.

You must not obtain or attempt to obtain any materials, documents or information
through any means not purposely made available through the Application.

You must not breach the security and the authentication measures of the Application or any
systems or networks connected to the Website, and/or probe, test or exploit the
vulnerabilities thereof and/or of the Services.

You must not attempt to disrupt and/or hack the Application and/or gain unauthorized access
to any Account or feature of the Website, and/or any of the systems and/or networks
connected to the Website, and/or any of the Services.

You must not pretend to represent, or to be another individual or entity, or manipulate
identifiers or forge headers in order to hide the origin of any message or transmittal you
send to us or through the Application or any Service.

You must not use, export, or re-export any Content or product or Service in violation of
any applicable laws or regulations, including without limitation, the United Arab
Emirates export laws and regulations.

You must not delete the copyright or other proprietary rights notice from any User
Content and/or the Content;

You must not reverse engineer, decipher, disassemble, tamper with, decompile, or bypass
any security associated with the Software, whether in whole or in part.

You must not upload or transmit viruses, Trojan Horses, or any malicious or destructive
software, that interferes, disrupts, impairs, alters or otherwise, with any Application user
and/or viewer’s uninterrupted use and enjoyment of the Application.

​

USER ACCOUNT

​

You may be held liable for losses incurred by us or any other user of the Application due to
(i) someone else using or having access to your Account; and/or (ii) your failure to
maintain the confidentiality and security of your password and login credentials.

You must not share, sell, or otherwise transfer your Account.

All rights not expressly granted to you in these Terms are reserved by us.

We may at our sole discretion delete your Account and any content or information that
you posted at any time, with warning.

Further to terminating or suspending your Account, we reserve the right to take
appropriate legal action, including without limitation pursuing criminal, civil and
injunctive redress.

 

REPRESENTATIONS AND WARRANTIES

You represent, warrant and covenant that:

​

You have the legal capacity to agree to comply with these Terms.

Your use of and/or access to this Application will not violate any applicable law or
regulation.

You are eligible to use the Website, and you are not a minor in the jurisdiction in which
you reside.​

​

PROPRIETARY RIGHTS

The Application is our proprietary property. We own and control, solely and exclusively, the
Website including without limitation, all source code, computer code, Software,
databases, audio, video, photographs, designs, page headers, text, graphics, button icons,
functionality, user interfaces, visual interfaces, music, sounds, scripts, practical features,
etc. contained in and on the Website (collectively, the “Content”) including without
limitation, the “look and feel”, design, expression, structure, arrangement of such Content
and the logos, trademarks, service marks, etc. also contained therein (collectively, the
“Marks”). All such Content and Marks are also licensed by or to us, and are protected by
intellectual property, copyright, patent, trade dress and trademark laws as well as unfair
competition laws.

Your use of the Application does not grant you ownership of any Content or Marks you may
access on the Application; and we reserve all rights not expressly granted to you in these
Terms in and to the Website, the Content and the Marks.

All other trademarks not owned by us that appear on our Application and/or in any of our
Services are the property of their respective owners, who may or may not be affiliated
with, connected to, or sponsored by us.

The Marks may not be used in connection with any product or service that is not our
product or service, in any manner that is likely to cause confusion among customers, or in
any manner that disparages or discredits us.

In the event that you are eligible to use the Website, you may download or print, only in a
limited manner, a copy of any portion of the Content or User Content to which you
authoritatively gained access exclusively for your personal, non-commercial use,
provided that you do not: (i) remove the proprietary notice language in all copies of such
limited Content and/or User Content; (ii) broadcast such information in any media; (iii)
copy or post such information on any networked device or computer; (iv) make
modification to any such User Content and/or Content, and/or (v) make any additional
representations or warranties relating to such Content and/or User Content.

No part of the Application and no User Content and/or Content may be reproduced, copied,
posted, aggregated, encoded, modified, sold, transmitted, translated, republished,
uploaded, publicly displayed, distributed or otherwise exploited for any commercial 

        enterprise whatsoever, without our prior, explicit and written consent.

You agree that all user content that you submit, post or display on or through the Application
is your sole responsibility. You represent and warrant that you own or have the necessary
licenses, rights, consents, and permissions to use and authorize us to use, reproduce,
adapt, modify, publish, translate, create derivative works from, distribute, perform, and
display all of your user content (the “User Content”) in connection with the Services,
and to sublicense such rights to third-parties.

​

​

​

THIRD-PARTY WEBSITES

​

You may not create a link to this Application through another website, application, portal,
platform or otherwise, without our explicit written consent.

 The Application may include links to other websites (the “Third-Party Websites”). We are
neither in control of nor responsible in any respect for such Third-Party Websites.
Furthermore, we are not responsible for and do not endorse the content, information,
materials, policies, and the accuracy and reliability of Third-Party Websites, as well as
any violations, prohibited activities etc. contained therein and accessed through the
Website. Inclusion of Third-Party Websites is not in any manner an endorsement or
approval thereof by us. You will need to make your own independent judgment regarding
your interaction with these Third-Party Websites, which you assume all responsibility
for.

​

PRIVACY POLICY

​

Please review our Privacy Policy and our Cookie Policy, which also govern your use of

        and access to our Services and Website.

You hereby acknowledge that Internet transmissions are neither completely private nor
secure. You understand that any message or information (e.g., address, etc.) that you send to the Application may be accessed or intercepted by others,
despite the specific notice that the transmission is encrypted.

We may disclose any information about you, including your identity, for the purposes set
forth below:

If such disclosure is necessary in relation to any complaint or investigation
regarding your use of and/or access to the Application;

To identify or take legal action against any person or entity who may be causing
interference with our rights, or the rights of the visitors or users of the Application;

To comply with any applicable law, regulation, legal process and/or governmental
request; and

For any other lawful purposes.

 

You hereby agree that we may retain any communication you send to us through the

         Application and/or any Service, and we may disclose such data if required to do so by law or
         if we determine that such disclosure or retention is reasonably necessary to:

i. Comply with legal process;
ii. Enforce these Terms;
iii. Respond to claims that any such data violates the rights of others; and
iv. Protect the rights, property or our personal safety, our employees, users of or

visitors to the Application, as well as the public.

​

DISCLAIMER

1. You agree that your use of and/or access to the Application and our Services is
entirely at your sole risk, for which we shall not be responsible.
2.TO THE FULLEST EXTENT PERMITTED BY LAW, WE DISCLAIM ALL
WARRANTIES, REPRESENTATIONS AND GUARANTEES, EXPRESS OR
IMPLIED, IN CONNECTION WITH THE APPLICATION, CONTENT, MARKS,
SERVICES, USER CONTENT AND YOUR USE OF AND ACCESS TO THE
WEBSITE, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
ACCURACY, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR ANY PARTICULAR PURPOSE. WE MAKE NO WARRANTIES OR
REPRESENTATIONS ABOUT THE ACCURACY, TIMELINESS,
PERFORMANCE, COMPLETENESS OR SUITABILITY OF THE WEBSITE,
CONTENT AND MARKS OR USER CONTENT OR CONTENT OF ANY
THIRD-PARTY WEBSITES. THE WEBSITE AND ITS CONTENT ARE
DELIVERED ON AN “AS-IS” AND “AS-AVAILABLE” BASIS. WE WILL
ASSUME NO LIABILITY OR RESPONSIBILITY FOR:​

​​YOUR USE OF ANY LINKED SITES AND THIRD-PARTY WEBSITES;

ANY ACTS, OMISSIONS AND CONDUCT OF ANY THIRD PARTIES
IN CONNECTION WITH OR IN RELATION TO YOUR USE OF
AND/OR ACCESS TO THE APPLICATION AND/OR ANY OF OUR
SERVICES.

ANY OMISSIONS, ERRORS, MISTAKES, OR INACCURACIES OF
CONTENT AND OF USER CONTENT ON THE WEBSITE;

ANY UNAUTHORIZED ACCESS TO OR USE OF OUR
REASONABLY SECURE SERVERS AND/OR ANY FINANCIAL OR
PERSONAL INFORMATION RESERVED THEREIN;

ANY DOWNTIME OF THE WEBSITE;

ANY DELAY, CESSATION OR INTERRUPTION OF YOUR ACCESS
TO AND/OR USE OF THE APPLICATION OR TRANSMISSION TO OR
FROM THE WEBSITE;

PERSONAL INJURY OR PROPERTY DAMAGE, OF WHATSOEVER
NATURE, RESULTING FROM YOUR ACCESS TO AND/OR YOUR
USE OF WEBSITE, CONTENT AND/OR USER CONTENT;

DEFECT, VIRUSES, BUGS, DESTRUCTIVE FEATURES,
CONTAMINATION OR THE LIKE WHICH MAY BE TRANSMITTED
TO OR THROUGH THE WEBSITE BY ANY THIRD PARTY OR
USER, AND/OR;

LOSS OR DAMAGE OF ANY KIND, INCURRED DURING
DISCONTINUANCE OR DOWNTIME OF THE WEBSITE, OR IN
RELATION TO THE USE OF ANY CONTENT OR USER CONTENT
POSTED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE
VIA THE WEBSITE.

 

WE DO NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME

LIABILITY FOR ANY CONTENT, PRODUCT OR SERVICE ADVERTISED

OR OFFERED BY A THIRD PARTY THROUGH THE APPLICATION, ANY
HYPERLINKED WEBSITE, OR ANY WEBSITE, OR MOBILE
APPLICATION FEATURED IN ANY BANNER OR OTHER
ADVERTISEMENT, AND WE WILL NOT BE A PARTY TO OR IN ANY
WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION
BETWEEN YOU AND ANY THIRD-PARTY PROVIDERS OF PRODUCTS
OR SERVICES. YOU SHOULD USE YOUR BEST JUDGMENT AND
EXERCISE CAUTION WHERE APPROPRIATE.

 

YOUR SOLE REMEDY AGAINST MIKKI TECHNOLOGIES PVT LTD FOR

DISSATISFACTION WITH THE APPLICATION OR ANY CONTENT IS TO STOP
USING THE APPLICATION OR ANY SUCH CONTENT.​

 

Limitation of Liabality

​

Except where prohibited by law, in no event the Company will we be liable to you for
any indirect, consequential, exemplary, incidental, punitive damages, or otherwise,
including lost profits, time, opportunities and/or access to data, whether in an action,
based on breach of contract, tort, product liability, strict liability, statute, law or equity,
arising under or related to these Terms, even if we have been advised of the possibility of
such damages. You hereby waive any and all such claims against us and inter alia, the
owners, affiliates, shareholders, officers, employees, directors, agents, assigns,
predecessors, successors of the Company.

Notwithstanding the other provisions of these Terms, if we are found to be liable to you
for any damage or loss which arises out of or is in any way connected with your use of or
access to the Application or any Content, then our liability shall in no event exceed the
beyond 25,000 INR without any interests rate or actual amount of damages or losses
incurred, whichever is lesser.

Some jurisdictions do not allow limitations of liability; thus, the foregoing limitation may
not apply to you.


Indemnification and Release


You shall indemnify, defend and hold us, the owners, officers, shareholders, directors,

employees, predecessors, successors in interest, agents, licensors, subsidiaries, suppliers,
affiliates, assigns of the Company harmless from and against all claims, third-party
claims, losses, liabilities, demands, expenses, damages, and costs, including court costs
and attorney’s fees, in connection with or resulting from (i) any violation of these Terms;
or (ii) related to your use of and/or access to this Website and/or Services; (iii) any
decision you make based on information or Content or User Content made available to
you through the Application; (iv) any actual or alleged wrongful or negligent act or omission
by you or anyone Application on your behalf; (v) your infringement of intellectual property
rights and/or any proprietary rights of any entity or person in connection with these
Terms and your use of and/or access to the Website and/or Services.

​

You agree to release us from claims, demands as well as damages of any kind
whatsoever, whether disclosed or undisclosed, actual or alleged, known or unknown,
suspected or unsuspected, direct or consequential, arising out of or relating to in any way
with disputes with any third-parties. To the maximum extent permitted by law, you also
agree to waive any rights that would otherwise limit this release.


Injunctive Relief

You also agree that any violation by you of these Terms will constitute an unlawful and unfair
business practice, and will cause irreparable harm to us, for which monetary damages would be
inadequate, and you consent to us obtaining any injunctive or equitable relief that we deem
necessary or appropriate in such circumstances. These remedies are in addition to any other
remedies we may have at law or in equity.


Governing Law and Dispute Resolution

The Terms of Use and the Policies shall be construed in accordance with the applicable
laws of India. For proceedings arising therein the Courts at Mumbai shall have exclusive
jurisdiction.

Any dispute or difference either in interpretation or otherwise, of the Terms of Use and
other Policies on the Site, between the parties hereto, shall be referred to the Court at
Mumbai.

Without any prejudice to particulars listed in this Terms and Condition, the Company
shall have the right to seek and obtain any injunctive, provisional or interim relief from
any court of competent jurisdiction to protect its trademark or other intellectual property
rights or confidential information or to preserve the status quo pending arbitration.

For disputes relating to orders outside India, International arbitration rules of Indian
Arbitration and Conciliation Act 1996 shall apply. The seat and venue of international
arbitration shall be Mumbai, the language shall be English and the number of Arbitrators
shall be 2, one of each will be appointed by either party.

Any claim under these Terms must be brought within one (1) year after the cause of
action arises, or such claim or cause of action is barred.

In the event of any dispute or controversy between us and you, which may arise out of or
in relation to your use of and/or access to the Application and/or Services, the parties shall
attempt, promptly and in good faith to resolve any such dispute. If we are unable to
resolve any such dispute within a reasonable period of time (within a 30-day period),
either party shall be free to pursue any right or remedy available to them in conformity
with these Terms and the applicable law.

​

Class Action Waiver

You agree that (a) class action and representative action procedures are hereby waived; (b) you
will not assert class action or representative action claims; (c) you will only submit your own,
individual claims and will not seek to represent the interests of any person, or consolidate claims
with any other person; (d) nothing in these Terms will be interpreted as your intent to adjudicate
disputes on a class or representative basis; and (e) any relief awarded to any one user of the
Application cannot and may not otherwise preside over any form of a consolidated, representative,
or class proceeding.


Term and Termination

a. These Terms shall remain in full force and effect while you use and/or access the Application
and/or Services.
b. We reserve the right, at any time, without liability or notice to you, to terminate operation

of the Application and/or deny access to and use of the Application and/or Account, or any portion thereof,

for any reason or no reason, including without limitation for any breach
of any representation, warranty, or covenant stipulated in these Terms or in any
applicable law or regulation.

​

Modifications

a. We reserve the right, at any time and at our sole discretion, with or without notice to you,
to (i) change, modify, add or remove portions of these Terms and our policies; (ii)
suspend operation of or your access to the Application and/or Account or any portion
thereof, (iii) change and update the Website and/or its Content or User Content; and/or
(iv) otherwise perform routine or non-routine maintenance to the Application.


b. Please check periodically for the most current version of these Terms. By continuing to
use the Application following the posting of changes, you accept and agree to the changes
that have been made by us.

​

Feedback

Any feedback you provide at this Website shall be deemed to be non-confidential. We
reserve the right to use such information on an unrestricted basis without
acknowledgement or compensation to you.

 

Severability

If any provision of these Terms is held to be illegal, invalid, or for any reason unenforceable, in
whole or in part, by a court or other tribunal of competent jurisdiction, that provision shall be
deemed severable and shall be eliminated or limited to the minimum extent necessary, and
replaced with a valid provision that best corresponds with the intent of these Terms, so it does
not affect the validity and enforceability of any remaining provision, which shall remain in full
force and effect.

​

Unsolicited Idea Submission Policies

We do not accept unsolicited ideas, suggestions or proposals. This includes ideas for new
products, services, marketing campaigns, technologies, processes or otherwise. If you send us

any of the aforementioned, we make no assurances that your ideas and materials will be treated
as confidential or proprietary, or will be compensated.

​

Entire Agreement

These Terms, the User Agreement, the Privacy Policy, the Cookie Policy and other policies
constitute the entire agreement and understanding between you and us with respect to your
access to or use of the Application and prevail over any terms proposed by you outside these Terms.
Any and all other, written or oral, previous or contemporaneous, agreements or understandings
existing between you and us with respect to such use of and/or access to the Application and/or
Services are hereby superseded by these Terms.

​

Waiver

a. Any failure by us to enforce or insist upon strict performance of any of these Terms, shall
not operate or be construed as a waiver by us of any provision or right in these Terms.
b. These Terms shall not be interpreted or construed to confer any rights or remedies on any
third parties.

​

Contact Us

If you have any inquiries or concerns about this Website, Terms and Conditions of Use, or
otherwise, we would like to hear from you. Please contact us at:
Email address: abansal11ae@gmail.com
Corporate address: Yamuna Tower, Jangid Complex, Mira Road (E), Mumbai 401107

​

Updated by the Mikki Technologies Pvt Ltd on March 08, 2024 ''';

  static String policy = '''We at Mikki Technologies PVT Ltd (Company, we, our, us) respect your privacy and are
committed to protecting your personal data. In this privacy policy, we explain how we collect,
use, and process your personal information when you access our mobile application (each, an App and together, Apps), for delivery of Services. Unless indicated
otherwise, this privacy policy further applies to any related websites or other online properties
owned or controlled by Company (together with the Websites and Apps, the Platforms). Services
mean to include all the content, services, information, and related made available to you “as is”
from our Platforms.


This Privacy Policy must be read in conjunction and together with the Terms of Use of the
particular Platform you are using. We recommend that you check their privacy policies before you access, use, or download from such
sites. We will not be responsible for the content, function, or information collection policies of
these external websites.


By accessing, downloading, using the Platform(s) and Application that we operate, which has a
direct link to this Policy, you agree to be governed by the Privacy Policy of the Company.
By agreeing to this Privacy Policy, you represent that you shall not access our Services by means
of any mechanism or technology which conceals your actual geo-location or provides incorrect
details of your location, (for example, use a virtual private network (VPN) to access our
Services. We shall not be responsible or liable for any processing or collection of your
information if you use these mechanisms to access our Platforms and Services.


Information We Collect
We will only collect your personal information where it is necessary for us to provide you with a
service at your request, such as when you contact us, register an account on our website, avail of
subscription services, or access the content on the Platform(s). We have discussed the manners of
our collection of information, herein in greater detail for your reference:


Information submitted to us:
You give us information about you whenever you use our services, such as by doing the
following, some of the following categories of information are collected directly by us, and some
are provided by you directly for the performance of certain functions:

 Accessing our Platforms by means of any web browser or device; on our Platforms;

Registration, subscribing for our Services

Enquiring about our products or services;

Purchasing our subscription packages on the Platforms;

Initiating and maintaining correspondence with us.

 

This information may include but not be limited to the following:

Identification information such as user name, date of birth, gender, profile picture, qualification, location;

Social media plugin details like – Google, or any other– for the purpose of identification

Contact information such as email address, mobile number;

Additional information relevant to your use of our Platforms and Services, such as one time password sent for registration,

         your marketing preferences, place of employment and designation, survey responses and feedback;

Financial information – Investment details, compensation details, salary range, where the

         relevant Service of the Platform requires such indicators.

​

We take extra precautions to ensure that such sensitive personal data is kept secure and
confidential, and we will only retain this data for as long as necessary for the purposes for which
we collect it.


Information we collect automatically:
We collect information using cookies and other similar technologies to help distinguish you from
other users of our Platforms, and streamline your online. When you visit our Platforms, we may
collect the following information:

​

 Your IP address/ device's serial number or unique identification number and general 

          location, including country, address and pin code;

A device identifier (cookie or IP address or Device ID or Android Advertiser ID / iDFAID), or any other identifier;

Details of the hardware and software that you are using to access the Platforms such as

         your computer/device name, your operating system, browser type and version,

         application version, operator name, screen size, CPU speed, and connection speed;

Any passwords that you use on our Platforms or any other authentication token used to login;

URL and time stamps;

Details of your visits to our Platforms and the resources that you access, including, but 

         not limited to, traffic data, location data, web logs and other communication data.

Your activity logs on the Platform(s) - Which pages you access, view and which links you follow;

​

Information we collect about you from other sources

We may collect information about you from other sources. This may include the following:

​

Publicly available information.

Information you have shared publicly, including on social media. We collect your e-mail

         ID and the relevant public profile information, which may include your name, profile

         picture, age, gender, and any other pertinent information from such social media account

         which is, necessary for verification of your identity.

We also receive information from you when you interact with our pages, Apps, groups,

         accounts, or posts on social media platforms.

This list is not exhaustive, and, in specific instances, we may need to collect additional

         data for the purposes set out in this policy.

​

Data Privacy & Security
As part of our commitment to data privacy and security, we uphold the highest standards of user

information confidentiality. However, it's important to note that by using the YouTube API services

integrated into Vivah AI, users are also subject to Google's Privacy Policy.

For a comprehensive understanding of how Google collects, manages, and protects your data,

please refer to Google's Privacy Policy.

​

User Consent
By continuing to access or use our API Client, users implicitly agree to comply with the YouTube Terms of Service.

It is the user's responsibility to periodically review the terms for any changes.

Non-compliance with these terms may result in the suspension or termination of the user's

access to the API Client and any related services.

 

Information we receive about you from other sources

Sometimes you will have given your consent to other websites, services or third parties to

provide information to us.

​

 It could include information from third parties that we work with to provide our product

       and services, such as delivery companies, technical support companies and advertising

        companies. Whenever we receive information about you from these third parties, we will

        only use it in such manner that is already communicated to you, as per this Policy, and for

        such defined purposes only. We may further collect additional analytics reports,

        information from other services, websites, who work together with us.

​

Marketing and Analytics

​​

We may use Web Beacons to track your online usage patterns in an anonymous manner,

         without collection your personally identifiable information. We may also use web

         beacons in HTML emails that we send subscribers who have opted in to receive email

         from us, to determine whether our recipients have opened those emails and/or clicked on

         links in those emails. We use this information to inter-alia deliver our web pages to you

​         upon request, to tailor our Platform(s) to the interests of our users, to measure traffic

         within our Platform(s) to improve the quality, functionality and interactivity of our

         Platform(s) and let advertisers know the geographic locations from where our Users come

         without personally identifying the users.

​

We place website beacons to collect data for our partners, we require our partners to

        inform users on their privacy policy page that the webpage uses website beacons. This

        option will only be recorded in your current browser and will not be recorded in your user

        history.

​

Purpose of Collection of Information

We collect information (including Personal Information) to provide the Services and for

the purposes as outlined below including but not limited to:

​

to help us identify you when you log into the Platform and when you register an

        account with us, and, to map a specific profile with an authorized user;

 to help facilitate in-app purchases and make subscribed and paid content available to you;

to enhance the quality of services that we provide and improve your experience during browsing;

to personalize your browsing experience on the Platform(s);

to recommend videos, content, news to users they might be interested in;

for providing location-based services;

for the performance of a contractual and legal obligation;

to communicate with you;

to provide you with news, special offers, general information, commercial

        communications about other products and services along with marketing

        information and surveys;

to provide and process service requests initiated by you.

Notification of any changes in the terms of use or privacy policy;

Resolution of any queries related to your use of Services.

Any other new services developed by us, our affiliates, subsidiaries and /or third party partners

​

Sharing and Use
1. We may share your information with our trusted partners or third parties who provide us
with support services, for meeting the obligations agreed to between you and us.


2. We may use and/or disclose your information with the Company-controlled businesses,
affiliates, subsidiaries and other entities within the Times group of companies, other
third-party business partners, service providers including but not limited to services
provider, advertising networks, technology partner, social networks and any other third
parties:


1. to assist them to reach out to you in relation to their programs or campaigns
(including marketing and sales) and to process your query / requests (such as job
application) and/or provide with the services;
2. to send e-mails, instant messages, social media messages and SMS messages
and/or manage contact management systems.
3. recommendations services, ad tech services, analytic services, including but not
limited to click stream information, browser type, time and date, information
about your interactions with advertisements and other content, including through
the use of cookies, beacons, mobile ad identifiers, and similar technologies, in
order to provide content, advertising, or functionality or to measure and analyze
ad performance, on our Services or Platforms and on 3rd party platforms.
4. serve ads on our Platforms, affiliate websites, and any other digital platform
available on the internet. However, the privacy policy of such digital platform
shall be applicable upon the processing of information on such third-party digital
platform.
5. to assist and to reach out to you in relation to various programs or campaigns
(including marketing and sales) and/or to process your query / requests.

​

3. We may further be required to share your personal information in certain exceptional
circumstances; this would be where we believe that the disclosure is:


1. Required by the law, or in order to comply with judicial proceedings, court orders
or legal or regulatory proceedings.
2. Necessary to protect the safety of our employees, our property or the public.

3. Necessary for the prevention or detection of crime, including exchanging
information with other companies or organizations for the purposes of fraud
protection and credit risk reduction.
4. Proportionate as part of a merger, business, or asset sale, in the event that this
happens we will share your information with the prospective seller or buyer
involved.


Data Retention

 

We will only store your personal information for as long as we need it for the purposes

        for which it was collected. Retention periods for records will also be based on the type of

        record, the nature of the activity and product and service that the same is associated with, linked to.

​

We retain your information till such period that is required for the purposes of us meeting

        your requests on our Platforms, and in compliance with the applicable laws, statutory

        requirements.

 

Information Security

​

We take commercially reasonable technical, physical, and organizational steps to

        safeguard any information you provide to us, to protect it from unauthorized access, loss,

        misuse, or alteration.

We try to ensure that all information you provide to us is transferred securely via the

         website (always check for the padlock symbol in your browser, and “https” in the URL,

         to ensure that your connection is secure).

All information you provide to us is stored on secure servers. Where we have given you

        (or where you have chosen) a password which enables you to access certain parts of our

        website, you are responsible for keeping this password confidential. We ask you not to

        share a password with anyone.

Although we take reasonable security precautions, no computer system or transmission of

        information can ever be completely secure or error-free, and you should not expect that

        your information will remain private under all circumstances. The Company will not be

        liable for any damages of any kind arising from the use of the Platform, including, but not

        limited to any indirect, incidental, special, consequential or punitive damages, or any loss

        of profits or revenues, whether incurred directly or indirectly or any loss of data, use,

        good-will, or other intangible losses.


Data Subject Rights

​

If you require any further information about your rights as explained below, or if you would like
to exercise any of your rights, please reach out to us by writing to the Grievance Officer of the
Company.

You have the right to access your personal data.

You have the right to correct any inaccurate or incomplete personal data

You have the right to withdraw your consent

You have the right to request deletion of your account

However, we may maintain backup copies of your information, to the extent necessary to comply
with our legal obligations.


Cross-Border Transfers
We operate globally and may transfer your personal information to individual companies of the
Times Internet Limited affiliated companies or third parties in locations around the world for the
purposes described in this privacy policy, only upon satisfaction that the country has an adequate
and appropriate level of protection, and the transfer of information is lawful. We shall comply
with our legal and regulatory obligations in relation to your Information, including having a
lawful basis for transferring Personal Information and putting appropriate safeguards in place to
ensure an adequate level of protection for the Personal Information. We will also ensure that the
recipient in such alternate country is obliged to protect your Information at a standard of
protection comparable to the protection under applicable laws. Our lawful basis for such transfer
will be either on the basis of content or one of the safeguards permissible by laws.


Children Privacy

You must have attained the age of majority to be able to use and access our Services. If

         you are a minor in your jurisdiction, your registration and use of our Services must be

         with the supervision of an adult.

As a parent or legal guardian, please do not allow your minors under your care to submit 

        Personal Information to us. In the event that such Personal Information of a minor is

        disclosed to us, you hereby consent to the processing of the minor’s Personal Information

        and accept and agree to be bound by this Privacy Policy and take responsibility for his or

        her actions.

However, if the Company is notified that the personal data of individuals below the age

        of majority has been collected by Us, without user or parental consent, We shall take all

        necessary steps to delete such information from our servers. As a parent or legal
        guardian, you are encouraged to reach out to the Grievance Officer, for redressal of any

        complaints in relation to collection of children data.

​

Changes to the Privacy Policy
Any changes we make to our privacy policy in the future, to incorporate necessary
changes in technology, applicable law, will be posted on this page and, where appropriate,
notified to you by e-mail. Your use of the Services after such notice shall be deemed as
acceptance of such changes to our Privacy Policy. Please check back frequently to see
any updates or changes to our privacy policy. This version was last updated on 08 March 2024.


Grievance Redressal
If you have any complaints, concerns with regards to the use, storage, deletion, and disclosure of
your personal information provided to Us, you may reach out to the Grievance Officer,
at hi@clearmind.plus.
Please ensure that you do not share any feedback communication with an unauthorized member
of the Company; the Company will not be responsible for the resolution of your query, in such
case. If you choose to write to Us, you must address such communication to “Grievance Officer”
and provide the following information:

1. Your identification details – Name, Times Identification ID, if applicable;
2. Details of your specific concern(s);
3. Clear statement as to whether the information is personal information or sensitive
personal information;
4. Your address, telephone number or e-mail address;
5. A statement that you have a good-faith belief that the information has been
processed incorrectly or disclosed without authorization, as the case may be;
6. A statement, under penalty of perjury, that the information in the notice is
accurate, and that the information being complained about belongs to you;
The Company may reach out to you to confirm or discuss certain details about your complaint
and issues raised. ''';
}