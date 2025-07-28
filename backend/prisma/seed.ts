import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting database seeding...')

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
      description: 'Standard Engineering Position'
    }
  })

  const seniorManagementFlow = await prisma.interviewFlow.create({
    data: {
      description: 'Senior Management Position'
    }
  })

  const entryLevelFlow = await prisma.interviewFlow.create({
    data: {
      description: 'Entry Level Position'
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
      title: 'Senior Software Engineer',
      description: 'Looking for an experienced software engineer to join our team',
      location: 'Barcelona',
      employmentType: 'Full-time',
      status: 'active',
      isVisible: true
    }
  })

  console.log('✅ Database seeding completed successfully!')
  console.log('\n📊 Summary of created data:')
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