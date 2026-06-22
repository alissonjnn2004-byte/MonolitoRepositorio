using QRCoder;
using System;
using System.IO;
using System.Net;
using System.Net.Mail;

namespace Capa_Negocio
{
    public class Mail
    {
        public static void EnviarOTP(
            string correoDestino,
            string codigoOTP
        )
        {
            try
            {
                // GENERAR QR
                QRCodeGenerator qrGenerator =
                    new QRCodeGenerator();

                QRCodeData qrCodeData =
                    qrGenerator.CreateQrCode(
                        codigoOTP,
                        QRCodeGenerator.ECCLevel.Q
                    );

                PngByteQRCode qrCode =
                    new PngByteQRCode(qrCodeData);

                byte[] qrCodeBytes =
                    qrCode.GetGraphic(40);

                // STREAM
                MemoryStream ms =
                    new MemoryStream(qrCodeBytes);

                ms.Position = 0;

                // CORREO
                MailMessage mail =
                    new MailMessage();

                mail.From =
                    new MailAddress(
                        "alissonjnn2004@gmail.com"
                    );

                mail.To.Add(correoDestino);

                mail.Subject =
                    "Código QR de acceso";

                mail.IsBodyHtml = true;

                string html =
    $@"
    <div style='font-family:Arial;padding:20px;'>

        <h2 style='color:#7caf6e;'>
            Código de acceso
        </h2>

        <p>
            Hola, este es tu código temporal para ingresar al sistema.
        </p>

        <h3 style='background:#f2f2f2;
                   padding:15px;
                   border-radius:10px;
                   width:200px;
                   text-align:center;
                   letter-spacing:4px;'>

            {codigoOTP}

        </h3>

        <p>
            Puedes:
        </p>

        <ul>
            <li>Escanear el código QR</li>
            <li>O escribir el código manualmente</li>
        </ul>

        <br/>

        <img src='cid:QRImage'
             style='width:250px;height:250px;' />

    </div>
    ";

                AlternateView avHtml =
                    AlternateView
                    .CreateAlternateViewFromString(
                        html,
                        null,
                        "text/html"
                    );

                LinkedResource qrImage =
                    new LinkedResource(
                        ms,
                        "image/png"
                    );

                qrImage.ContentId =
                    "QRImage";

                qrImage.TransferEncoding =
                    System.Net.Mime.TransferEncoding.Base64;

                avHtml.LinkedResources
                    .Add(qrImage);

                mail.AlternateViews
                    .Add(avHtml);

                // SMTP
                // --- SECCIÓN CORREGIDA ---
                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);

                // PRIMERO desactivamos las credenciales por defecto
                smtp.UseDefaultCredentials = false;

                // SEGUNDO asignamos tus credenciales
                smtp.Credentials = new NetworkCredential(
                    "alissonjnn2004@gmail.com",
                    "pjpy gelg yblf qukf"
                );

                smtp.EnableSsl = true;
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Timeout = 20000;

                // ENVIAR
                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                throw new Exception(
                    ex.ToString()
                );
            }
        }

    }
    
    
}