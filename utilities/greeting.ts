import Holidays from 'date-holidays'

export default function getGreeting(countryCode: string = 'CA', provinceCode: string = 'QC'): string {
  const now = new Date()
  const hours = now.getHours()

  const hd = new Holidays(countryCode, provinceCode)
  const todayHoliday = hd.isHoliday(now)

  if (todayHoliday) {
    return 'Joyeuse fête'
  }

  if (hours >= 5 && hours < 12) {
    return 'Bonjour'
  } else if (hours >= 12 && hours < 18) {
    return 'Bon après-midi'
  } else {
    return 'Bonsoir'
  }
}
