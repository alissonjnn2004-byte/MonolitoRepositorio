using System;
using System.Security.Cryptography;
using System.Text;

namespace Monolito_4am.Utilidades
{
    public class SeguridadOTP
    {
        // ENCRIPTAR OTP
        public static string EncriptarSHA256(string texto)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes =
                    sha256.ComputeHash(
                        Encoding.UTF8.GetBytes(texto)
                    );

                StringBuilder builder =
                    new StringBuilder();

                foreach (byte b in bytes)
                {
                    builder.Append(
                        b.ToString("x2")
                    );
                }

                return builder.ToString();
            }
        }
    }
}
