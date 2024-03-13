

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static Future<String> getToken() async{
    var serviceAccountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "notification-c2170",
      "private_key_id": "b7621847fff9c4906894b1dd82b8ec649870cd39",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDOEF+YlxCk/P3L\nJjm99wlZ/LqDFqn+cjm4+RvjXzQ37FNKn8MW8VPa/1wPrSuFlBwhZ1z8ke2GG+lh\n6YZE/20RxMHNdnj/2NZ6vonnPbDBso3LqNGpOXssM/rD4AkxLt7ZEqmGcoD3NBkR\neNJ43TgoZJTlwE2D0VTHWVh6uDB24gPx7T21JInIGTP7D8/dwsH2vghTyiTnF8+w\n1JO2Li/6PLbyKBT658oUx+50rlaYwMnCjUNw8TieFyQiQ0sTUMlGRI7C0PoJ43n3\nZ7ofdBwSgiB3B3fKGeTbKMHrLEKe4mKob7vtNvLTQD3t6r1LjVWHpPkimALqfoMX\nmkiS1LixAgMBAAECggEAQrIR/vWGMaChFIu+zLmUkUe3po5DX1PhUvluCV3bLO6U\n1uZ24oohthRI29oU6BtUL4uhES66TlniZAqNpu91gfbJM5NQ/p5UbU4WnH3fJBKC\nypRNqBQuxdPdKmDtGLou7tuXeyi8jUaThpAwr2YKsyg6+VIQxMWQRyWn+bB8Hz3b\nID0GgCZcWkRV+zvaAieLdn8/vPF+PF5NTC+CvoGHyBZyl561POc3mg53xkLxHkWo\n6O9tutmrVzvLrDeTT+2fawM9+L5/XiRcnW/qI3amcMnWS4cXbKfMx95I1/UwhnXJ\npm2eMVVdHd3krNMjeIARwTkU54Q6wbhqA8Lx3OcxsQKBgQD4NwXsAjMZJwLZzwQM\ngFEbstnt4yJb6bAfofKJIcEct6KTQvn+dVJtc8y0DPckWsgJJMySablMJFbMZD8C\n+wIwmevDEG4Tb8nKP3ivWulYftVKnJAg5IKLpbfQhVgRa/Vlf895IQoLWw34jrly\nvJ3jogdtlKU65Jx3F/9sU3WGSwKBgQDUhuj5xt7Aa2XPJYG7LrIHOWH58u8AABoX\nJIAOj+7n/JO8HEPNGdRB6um7DEyQs2PiLxpzNZG8etLktC2DhuSLiO3zw87LB4rC\nqy7RYHWYw5vB2esdTu+HXP1Evan+kCoODVwW+hcBmGhOzQT4vMDhileeLmY6BiJm\naiKjF6EPcwKBgENzKE/O9TXDjRnFEJOZFvFQ87maPE7/vNWLu42aN5DnMe2UiLym\nAwUtL5ZJ46rkZHFfp5ut0SWoxlF6eEkGDr1IRnHWeCMeAJbOEqyMJtbeeHVzABOA\nJR1vpfirE5iAXsn7JlUDLmiRkMVXe3t7V+hwslYLy66qSv5t7gHw2AHrAoGBAJ15\nGUd6Q7Lv4RAMCoRXpTIVIrPBfbXSXYKoWPpxS+Q5En5fsx1V9iChn24pPtI5GdmO\nbVrQZpvxpjIwD0lVuiJp42arv55QiFCV5qrdfkUjK1YH0l51DqaOEFvO7RbiW0bu\nPz4HMOTNuPwqjXSA56o2h5V9a+Gyieq42dFewMhhAoGBAJILoJiFal6rwN8mIJSd\nft25UH8F05NyRh8+Tcr4LA1Qm3UfMaYS7oc4O/Z4xWCIVWr3tmjLJyOkMT/Emwr/\nDxXAYelgNCLJzK8XHuq+6qIUKv4ZnxvFfvcg5emwiVY2TTXxl0677Dv1cJg98pX0\nTWcmHAivRA3Y9PqD0LWNx+5d\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-p6hsj@notification-c2170.iam.gserviceaccount.com",
      "client_id": "103714506250897004890",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-p6hsj%40notification-c2170.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    var accessCredentials = await obtainAccessCredentialsViaServiceAccount(serviceAccountCredentials, scopes, http.Client());    
    return accessCredentials.accessToken.data;
  }
}
