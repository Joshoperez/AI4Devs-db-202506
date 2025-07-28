import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting optimized database seeding...')

  // Clean up existing data (optional - comment out if you want to keep existing data)
  console.log('🧹 Cleaning up existing data...')
  await prisma.interview.deleteMany()
  await prisma.application.deleteMany()
  await prisma.interviewStep.deleteMany()
  await prisma.position.deleteMany()
  await prisma.employee.deleteMany()
  await prisma.interviewFlow.deleteMany()
  await prisma.interviewType.deleteMany()
  await prisma.company.deleteMany()
  await prisma.employmentType.deleteMany()
  await prisma.location.deleteMany()
  await prisma.applicationStatus.deleteMany()
  await prisma.interviewResult.deleteMany()
  await prisma.positionStatus.deleteMany()

  // Create normalized lookup data
  console.log('📋 Creating normalized lookup data...')

  // Employment Types
  const fullTime = await prisma.employmentType.create({
    data: {
      name: 'Full-time',
      description: 'Full-time employment with benefits'
    }
  })

  const partTime = await prisma.employmentType.create({
    data: {
      name: 'Part-time',
      description: 'Part-time employment'
    }
  })

  const contract = await prisma.employmentType.create({
    data: {
      name: 'Contract',
      description: 'Contract-based employment'
    }
  })

  const internship = await prisma.employmentType.create({
    data: {
      name: 'Internship',
      description: 'Internship position'
    }
  })

  // Locations
  const barcelona = await prisma.location.create({
    data: {
      city: 'Barcelona',
      state: 'Catalonia',
      country: 'Spain'
    }
  })

  const madrid = await prisma.location.create({
    data: {
      city: 'Madrid',
      state: 'Madrid',
      country: 'Spain'
    }
  })

  const remote = await prisma.location.create({
    data: {
      city: 'Remote',
      state: null,
      country: 'Global'
    }
  })

  // Application Statuses
  const pending = await prisma.applicationStatus.create({
    data: {
      name: 'Pending',
      description: 'Application is under review',
      color: '#FFA500'
    }
  })

  const reviewing = await prisma.applicationStatus.create({
    data: {
      name: 'Reviewing',
      description: 'Application is being reviewed',
      color: '#4169E1'
    }
  })

  const accepted = await prisma.applicationStatus.create({
    data: {
      name: 'Accepted',
      description: 'Application has been accepted',
      color: '#32CD32'
    }
  })

  const rejected = await prisma.applicationStatus.create({
    data: {
      name: 'Rejected',
      description: 'Application has been rejected',
      color: '#DC143C'
    }
  })

  const withdrawn = await prisma.applicationStatus.create({
    data: {
      name: 'Withdrawn',
      description: 'Application has been withdrawn by candidate',
      color: '#808080'
    }
  })

  // Interview Results
  const passed = await prisma.interviewResult.create({
    data: {
      name: 'Passed',
      description: 'Candidate passed the interview'
    }
  })

  const failed = await prisma.interviewResult.create({
    data: {
      name: 'Failed',
      description: 'Candidate failed the interview'
    }
  })

  const pendingResult = await prisma.interviewResult.create({
    data: {
      name: 'Pending',
      description: 'Interview result is pending'
    }
  })

  const rescheduled = await prisma.interviewResult.create({
    data: {
      name: 'Rescheduled',
      description: 'Interview was rescheduled'
    }
  })

  // Position Statuses
  const active = await prisma.positionStatus.create({
    data: {
      name: 'Active',
      description: 'Position is currently accepting applications'
    }
  })

  const closed = await prisma.positionStatus.create({
    data: {
      name: 'Closed',
      description: 'Position is no longer accepting applications'
    }
  })

  const draft = await prisma.positionStatus.create({
    data: {
      name: 'Draft',
      description: 'Position is in draft mode'
    }
  })

  const paused = await prisma.positionStatus.create({
    data: {
      name: 'Paused',
      description: 'Position is temporarily paused'
    }
  })

  // Create sample companies
  console.log('🏢 Creating sample companies...')
  const techCorp = await prisma.company.create({
    data: {
      name: 'TechCorp'
    }
  })

  const innovateSoft = await prisma.company.create({
    data: {
      name: 'InnovateSoft'
    }
  })

  const digitalSolutions = await prisma.company.create({
    data: {
      name: 'Digital Solutions'
    }
  })

  // Create sample interview types
  console.log('📋 Creating interview types...')
  const phoneScreening = await prisma.interviewType.create({
    data: {
      name: 'Phone Screening',
      description: 'Initial phone interview to assess basic qualifications and interest'
    }
  })

  const technicalInterview = await prisma.interviewType.create({
    data: {
      name: 'Technical Interview',
      description: 'Technical skills assessment and problem-solving evaluation'
    }
  })

  const behavioralInterview = await prisma.interviewType.create({
    data: {
      name: 'Behavioral Interview',
      description: 'Assessment of soft skills, cultural fit, and past experiences'
    }
  })

  const finalInterview = await prisma.interviewType.create({
    data: {
      name: 'Final Interview',
      description: 'Final round with senior management or hiring manager'
    }
  })

  // Create sample interview flows
  console.log('🔄 Creating interview flows...')
  const standardEngineeringFlow = await prisma.interviewFlow.create({
    data: {
      name: 'Standard Engineering Position',
      description: 'Typical interview process for software engineering positions'
    }
  })

  const seniorManagementFlow = await prisma.interviewFlow.create({
    data: {
      name: 'Senior Management Position',
      description: 'Interview process for senior and management positions'
    }
  })

  const entryLevelFlow = await prisma.interviewFlow.create({
    data: {
      name: 'Entry Level Position',
      description: 'Simplified interview process for entry-level positions'
    }
  })

  // Create interview steps for Standard Engineering Position
  console.log('📝 Creating interview steps...')
  await prisma.interviewStep.createMany({
    data: [
      {
        interviewFlowId: standardEngineeringFlow.id,
        interviewTypeId: phoneScreening.id,
        name: 'Initial Phone Screening',
        orderIndex: 1
      },
      {
        interviewFlowId: standardEngineeringFlow.id,
        interviewTypeId: technicalInterview.id,
        name: 'Technical Assessment',
        orderIndex: 2
      },
      {
        interviewFlowId: standardEngineeringFlow.id,
        interviewTypeId: behavioralInterview.id,
        name: 'Behavioral Interview',
        orderIndex: 3
      },
      {
        interviewFlowId: standardEngineeringFlow.id,
        interviewTypeId: finalInterview.id,
        name: 'Final Interview',
        orderIndex: 4
      }
    ]
  })

  // Create sample employees
  console.log('👥 Creating sample employees...')
  const johnDoe = await prisma.employee.create({
    data: {
      companyId: techCorp.id,
      name: 'John Doe',
      email: 'john.doe@techcorp.com',
      role: 'HR Manager'
    }
  })

  const janeSmith = await prisma.employee.create({
    data: {
      companyId: techCorp.id,
      name: 'Jane Smith',
      email: 'jane.smith@techcorp.com',
      role: 'Technical Lead'
    }
  })

  // Create sample position
  console.log('💼 Creating sample position...')
  const seniorEngineerPosition = await prisma.position.create({
    data: {
      companyId: techCorp.id,
      interviewFlowId: standardEngineeringFlow.id,
      positionStatusId: active.id,
      locationId: barcelona.id,
      employmentTypeId: fullTime.id,
      title: 'Senior Software Engineer',
      description: 'Looking for an experienced software engineer to join our team',
      jobDescription: 'We are seeking a Senior Software Engineer to join our development team...',
      requirements: '5+ years of experience in software development, proficiency in JavaScript, React, Node.js...',
      responsibilities: 'Design and implement scalable software solutions, mentor junior developers...',
      salaryMin: 60000.00,
      salaryMax: 80000.00,
      benefits: 'Health insurance, flexible working hours, remote work options...',
      companyDescription: 'TechCorp is a leading technology company...',
      applicationDeadline: new Date('2024-12-31'),
      contactInfo: 'hr@techcorp.com'
    }
  })

  console.log('✅ Optimized database seeding completed successfully!')
  console.log('\n📊 Summary of created data:')
  console.log(`- Employment Types: 4`)
  console.log(`- Locations: 3`)
  console.log(`- Application Statuses: 5`)
  console.log(`- Interview Results: 4`)
  console.log(`- Position Statuses: 4`)
  console.log(`- Companies: 3`)
  console.log(`- Interview Types: 4`)
  console.log(`- Interview Flows: 3`)
  console.log(`- Interview Steps: 4 (for Standard Engineering flow)`)
  console.log(`- Employees: 2`)
  console.log(`- Positions: 1`)
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  }) 