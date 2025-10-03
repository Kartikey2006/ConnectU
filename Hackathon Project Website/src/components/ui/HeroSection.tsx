import { ReactNode } from 'react'
import { Button } from './Button'

interface HeroSectionProps {
  title: string
  subtitle: string
  description?: string
  backgroundImage?: string
  children?: ReactNode
  buttonText?: string
  buttonAction?: () => void
  gradient?: boolean
}

export function HeroSection({ 
  title, 
  subtitle, 
  description, 
  backgroundImage = 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
  children,
  buttonText,
  buttonAction,
  gradient = true
}: HeroSectionProps) {
  return (
    <div className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background Image */}
      <div 
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: `url(${backgroundImage})` }}
      >
        <div className={`absolute inset-0 ${gradient ? 'bg-gradient-to-r from-blue-900/80 to-purple-900/80' : 'bg-black/50'}`} />
      </div>
      
      {/* Content */}
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="max-w-4xl mx-auto">
          {/* Subtitle */}
          <p className="text-xl text-blue-100 mb-4 font-medium">
            {subtitle}
          </p>
          
          {/* Title */}
          <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold text-white mb-6 leading-tight">
            {title}
          </h1>
          
          {/* Description */}
          {description && (
            <p className="text-xl text-gray-200 mb-8 max-w-3xl mx-auto leading-relaxed">
              {description}
            </p>
          )}
          
          {/* Button */}
          {buttonText && buttonAction && (
            <div className="mb-12">
              <Button 
                size="lg" 
                className="text-lg px-8 py-4"
                onClick={buttonAction}
              >
                {buttonText}
              </Button>
            </div>
          )}
          
          {/* Additional Content */}
          {children}
        </div>
      </div>
      
      {/* Scroll Indicator */}
      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce">
        <div className="w-6 h-10 border-2 border-white rounded-full flex justify-center">
          <div className="w-1 h-3 bg-white rounded-full mt-2 animate-pulse"></div>
        </div>
      </div>
    </div>
  )
}
