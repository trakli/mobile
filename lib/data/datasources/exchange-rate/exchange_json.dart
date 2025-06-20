/// Fallback exchange rate data used when remote API is unavailable.
/// Base currency: XAF (Central African CFA Franc)
/// This data should be updated periodically or replaced with a more dynamic solution.
library;

const exchangeJson = {
  "result": "success",
  "provider": "https://www.exchangerate-api.com",
  "documentation": "https://www.exchangerate-api.com/docs/free",
  "terms_of_use": "https://www.exchangerate-api.com/terms",
  "time_last_update_unix": 1747699351,
  "time_last_update_utc": "Tue, 20 May 2025 00:02:31 +0000",
  "time_next_update_unix": 1747787341,
  "time_next_update_utc": "Wed, 21 May 2025 00:29:01 +0000",
  "time_eol_unix": 0,
  "base_code": "XAF",
  "rates": {
    "XAF": 1,
    "AED": 0.00629,
    "AFN": 0.120307,
    "ALL": 0.1499,
    "AMD": 0.662397,
    "ANG": 0.003066,
    "AOA": 1.6025,
    "ARS": 1.942749,
    "AUD": 0.002657,
    "AWG": 0.003066,
    "AZN": 0.002917,
    "BAM": 0.002982,
    "BBD": 0.003426,
    "BDT": 0.208227,
    "BGN": 0.002982,
    "BHD": 0.000644,
    "BIF": 5.047341,
    "BMD": 0.001713,
    "BND": 0.002218,
    "BOB": 0.011859,
    "BRL": 0.009727,
    "BSD": 0.001713,
    "BTN": 0.146379,
    "BWP": 0.023287,
    "BYN": 0.005298,
    "BZD": 0.003426,
    "CAD": 0.00239,
    "CDF": 4.942138,
    "CHF": 0.00143,
    "CLP": 1.619762,
    "CNY": 0.012358,
    "COP": 7.198403,
    "CRC": 0.867696,
    "CUP": 0.041107,
    "CVE": 0.168098,
    "CZK": 0.037951,
    "DJF": 0.304401,
    "DKK": 0.011373,
    "DOP": 0.100928,
    "DZD": 0.22785,
    "EGP": 0.085651,
    "ERN": 0.025692,
    "ETB": 0.229059,
    "EUR": 0.001524,
    "FJD": 0.003889,
    "FKP": 0.001282,
    "FOK": 0.011374,
    "GBP": 0.001282,
    "GEL": 0.004699,
    "GGP": 0.001282,
    "GHS": 0.021047,
    "GIP": 0.001282,
    "GMD": 0.124382,
    "GNF": 14.904241,
    "GTQ": 0.013157,
    "GYD": 0.356857,
    "HKD": 0.013398,
    "HNL": 0.044583,
    "HRK": 0.011486,
    "HTG": 0.223112,
    "HUF": 0.613323,
    "IDR": 28.186835,
    "ILS": 0.006066,
    "IMP": 0.001282,
    "INR": 0.146367,
    "IQD": 2.238746,
    "IRR": 72.923599,
    "ISK": 0.222431,
    "JEP": 0.001282,
    "JMD": 0.272003,
    "JOD": 0.001214,
    "JPY": 0.248327,
    "KES": 0.221281,
    "KGS": 0.149842,
    "KHR": 6.803463,
    "KID": 0.002656,
    "KMF": 0.75,
    "KRW": 2.383086,
    "KWD": 0.000526,
    "KYD": 0.001427,
    "KZT": 0.876309,
    "LAK": 37.327548,
    "LBP": 153.296039,
    "LKR": 0.512963,
    "LRD": 0.34265,
    "LSL": 0.030959,
    "LYD": 0.009408,
    "MAD": 0.015865,
    "MDL": 0.029804,
    "MGA": 7.690988,
    "MKD": 0.093917,
    "MMK": 4.856663,
    "MNT": 6.103411,
    "MOP": 0.013798,
    "MRU": 0.067885,
    "MUR": 0.078523,
    "MVR": 0.026486,
    "MWK": 2.984243,
    "MXN": 0.033146,
    "MYR": 0.007359,
    "MZN": 0.109212,
    "NAD": 0.030959,
    "NGN": 2.743546,
    "NIO": 0.06305,
    "NOK": 0.017666,
    "NPR": 0.234206,
    "NZD": 0.002892,
    "OMR": 0.000659,
    "PAB": 0.001713,
    "PEN": 0.006316,
    "PGK": 0.007114,
    "PHP": 0.095537,
    "PKR": 0.482346,
    "PLN": 0.006493,
    "PYG": 13.777476,
    "QAR": 0.006235,
    "RON": 0.00768,
    "RSD": 0.178963,
    "RUB": 0.138183,
    "RWF": 2.480699,
    "SAR": 0.006423,
    "SBD": 0.014633,
    "SCR": 0.025102,
    "SDG": 0.762542,
    "SEK": 0.0166,
    "SGD": 0.002219,
    "SHP": 0.001282,
    "SLE": 0.038963,
    "SLL": 38.963018,
    "SOS": 0.975543,
    "SRD": 0.062934,
    "SSP": 7.927274,
    "STN": 0.03735,
    "SYP": 22.094884,
    "SZL": 0.030959,
    "THB": 0.056724,
    "TJS": 0.017869,
    "TMT": 0.006016,
    "TND": 0.005156,
    "TOP": 0.004072,
    "TRY": 0.066563,
    "TTD": 0.011687,
    "TVD": 0.002656,
    "TWD": 0.051603,
    "TZS": 4.626792,
    "UAH": 0.071471,
    "UGX": 6.255037,
    "USD": 0.001713,
    "UYU": 0.071484,
    "UZS": 22.097517,
    "VES": 0.162728,
    "VND": 44.478504,
    "VUV": 0.207102,
    "WST": 0.004679,
    "XCD": 0.004625,
    "XCG": 0.003066,
    "XDR": 0.001268,
    "XOF": 1,
    "XPF": 0.18192,
    "YER": 0.418457,
    "ZAR": 0.030957,
    "ZMW": 0.046106,
    "ZWL": 0.04582
  }
};
