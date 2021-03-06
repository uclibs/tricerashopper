module OrdersHelper

  def cost_in_dollars cost
    cost.to_d/100 if cost
  end

  def currency_list
    ['USD',
     'AUD',
     'CAD',
     'CHF',
     'DKK',
     'EUR',
     'GBP', 
     'ILS',
     'JPY',
     'MXN',
     'NAK',
     'NZD',
     'SEK',
     'SGD']
  end
  
  def fund_code_list
     ['TEST',
      'HALHN',
      'HBERN',
      'HDANN',
      'HHACN',
      'HHAUM',
      'HHGPN',
      'HHLON',
      'HHOLN',
      'HHPLN',
      'HHRCM',
      'HHRCN',
      'HHRM',
      'HHRZN',
      'HINGN',
      'HKREM',
      'HNGM',
      'HPHN',
      'HSIVN',
      'HSLEN',
      'HYSTN',
      'NAFRO',
      'NANTH',
      'NASIA',
      'NBIOL',
      'NBUSA',
      'NCAS',
      'NCCM',
      'NCHEM',
      'NCLAS',
      'NCOMA',
      'NCOMP',
      'NCRCL',
      'NCRMJ',
      'NDAAP',
      'NDOCS',
      'NEDUC',
      'NEDUE',
      'NENGL',
      'NENGR',
      'NENVi',
      'NFREN',
      'NGENL',
      'NGEOG',
      'NGEOL',
      'NGERM',
      'NHIST',
      'NHUMS',
      'NJUDA',
      'NLANG',
      'NLATA',
      'NLING',
      'NLREF',
      'NMATH',
      'NMIDE',
      'NPHIL',
      'NPHYS',
      'NPOLS',
      'NPROF',
      'NPSYC',
      'NSLAV',
      'NSOC',
      'NSOCW',
      'NSPAN',
      'NTHTR',
      'NWOMS',
      'SEDUE',
      'UARTB',
      'UCRCE',
      'UCRCL',
      'UELIG',
      'UENVi',
      'ULATA',
      'UUCOL',
      'VENVi',
      'VHUMS',
      'VLATA',
      'WUCHP',
      'XALTU',
      'XCCMU',
      'XDREU',
      'XRUBU',
      'XSCHU',
      'XVALU',
      'XWEBU',
      'XWMSU',
      'YARMU',
      'YBALU',
      'YBOTU',
      'YBREU',
      'YCANA',
      'YDAJU',
      'YDAYU',
      'YELLU',
      'YFLOU',
      'YHFRU',
      'YHGEU',
      'YHINU',
      'YHUNU',
      'YKRUU',
      'YLANU',
      'YLECN',
      'YNREU',
      'YOESU',
      'YRICH',
      'YSEAU',
      'YSEMU',
      'YSMGU',
      'YSTRU',
      'YTERU',
      'YTPIU',
      'YUCWU',
      'YURBN',
      'YURDU',
      'YVROU',
      'YWOOU',
      'ZRRPU']
  end

  def location_code_list
      ['OTEST',
      'HHBRO',
      'HHRSH',
      'HHSTK',
      'HYARC',
      'UAS',
      'UCB',
      'UCL',
      'UCLG',
      'UCM',
      'UCR',
      'UCRB',
      'UCRC',
      'UCRCO',
      'UCRE',
      'UCRES',
      'UCRL',
      'UCRR',
      'UCRUE',
      'UCRUK',
      'UCRV',
      'UCRX',
      'UDA',
      'UDAB',
      'UEL',
      'UEN',
      'UGP',
      'UINT',
      'ULA',
      'ULAH',
      'UMA',
      'ULAK',
      'ULADF']
  end

  def format_list
     ['Print',
      'DVD',
      'Streaming Video',
      'Other']
  end

  def language_list
    { 'English' => 'eng', 
      'Amharic' => 'amh', 
      'Arabic' => 'ara',
      'Armenian' => 'arm',
      'Bengali' => 'ben',
      'Cajun French' => 'roa',
      'Chinese' => 'chi',
      'Croatian' => 'hrv',
      'Czech' => 'cze',
      'Danish' => 'dan',
      'Dutch' => 'dut',
      'Finnish' => 'fin',
      'French' => 'fre',
      'French Creole' => 'cpf',
      'German' => 'ger',
      'Greek' => 'gre',
      'Gujarati' => 'guj',
      'Hebrew' => 'heb',
      'Hindi' => 'hin',
      'Hungarian' => 'hun',
      'Iloko' => 'ilo',
      'Italian' => 'ita',
      'Japanese' => 'jpn',
      'Korean' => 'kor',
      'Kru' => 'kro',
      'Latin' => 'lat',
      'Lithuanian' => 'lit',
      'Malayalam' => 'mal',
      'Miao (Hmong)' => 'hmn',
      'Mon-Khmer' => 'khm',
      'Navajo' => 'nav',
      'Norwegian' => 'nor',
      'Panjabi' => 'pan',
      'Pennsylvania Dutch' => 'gem',
      'Persian' => 'per',
      'Polish' => 'pol',
      'Portuguese' => 'por',
      'Romanian' => 'rum',
      'Russian' => 'rus',
      'Samoan' => 'smo',
      'Serbian' => 'srp',
      'Slovak' => 'slo',
      'Spanish' => 'spa',
      'Swedish' => 'swe',
      'Syriac' => 'syr',
      'Tagalog' => 'tgl',
      'Thai (Laotian)' => 'tha',
      'Turkish' => 'tur',
      'Ukrainian' => 'ukr',
      'Urdu' => 'urd',
      'Vietnamese' => 'vie',
      'Yiddish' => 'yid',
      'Other' => ''
    }

  end
end
