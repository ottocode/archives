using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Mail;
using ConMan.App_Code.Entities;

namespace ConMan.App_Code.Email
{

    public class EmailManager
    {

        static MailAddress fromAddress = new MailAddress("conmanapplication@gmail.com", "Conman Admin");
        //var toAddress = new MailAddress("to@example.com", "To Name");
        const string fromPassword = "conmanistheman";
        const string subject = "Task Update Notification";
        const string body = "Body";

        static SmtpClient smtp = new SmtpClient
           {
               Host = "smtp.gmail.com",
               Port = 587,
               EnableSsl = true,
               DeliveryMethod = SmtpDeliveryMethod.Network,
               UseDefaultCredentials = false,
               Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
           };

        public static Boolean lazyNotify(Task thetask, User theuser){
            var toAddress = new MailAddress(theuser.Email, theuser.FirstName+ " " + theuser.LastName);

            var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = "Your task '" + thetask.Name + "' is pending.  Please log into ConMan for the latest news!"
            };
            smtp.Send(message);

            return false;
        }
    }

}