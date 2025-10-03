import { ReactNode } from 'react'
import { Card } from './Card'
import { Badge } from './Badge'

interface StatCardProps {
  title: string
  value: string | number
  change?: string
  changeType?: 'increase' | 'decrease' | 'neutral'
  icon?: ReactNode
  description?: string
  color?: 'blue' | 'green' | 'purple' | 'orange' | 'red' | 'indigo' | 'yellow'
  href?: string
}

export function StatCard({ 
  title, 
  value, 
  change, 
  changeType = 'neutral',
  icon, 
  description,
  color = 'blue',
  href
}: StatCardProps) {
  const colorClasses = {
    blue: 'from-blue-500 to-blue-600',
    green: 'from-green-500 to-green-600',
    purple: 'from-purple-500 to-purple-600',
    orange: 'from-orange-500 to-orange-600',
    red: 'from-red-500 to-red-600',
    indigo: 'from-indigo-500 to-indigo-600',
    yellow: 'from-yellow-500 to-yellow-600'
  }
  
  const changeColors = {
    increase: 'text-green-600 bg-green-100',
    decrease: 'text-red-600 bg-red-100',
    neutral: 'text-gray-600 bg-gray-100'
  }
  
  const changeIcons = {
    increase: '↗',
    decrease: '↘',
    neutral: '→'
  }
  
  const content = (
    <Card className="p-6 hover:shadow-2xl transition-all duration-300 group">
      <div className="flex items-center justify-between mb-4">
        <div className={`p-3 rounded-xl bg-gradient-to-r ${colorClasses[color]} shadow-lg group-hover:scale-110 transition-transform duration-300`}>
          {icon && <div className="text-white text-xl">{icon}</div>}
        </div>
        {change && (
          <Badge 
            variant={changeType === 'increase' ? 'success' : changeType === 'decrease' ? 'danger' : 'default'}
            className="flex items-center gap-1"
          >
            <span>{changeIcons[changeType]}</span>
            {change}
          </Badge>
        )}
      </div>
      
      <div className="space-y-2">
        <h3 className="text-sm font-medium text-gray-600 uppercase tracking-wide">
          {title}
        </h3>
        <p className="text-3xl font-bold text-gray-900 group-hover:text-blue-600 transition-colors duration-300">
          {value}
        </p>
        {description && (
          <p className="text-sm text-gray-500">
            {description}
          </p>
        )}
      </div>
    </Card>
  )
  
  if (href) {
    return (
      <a href={href} className="block">
        {content}
      </a>
    )
  }
  
  return content
}
